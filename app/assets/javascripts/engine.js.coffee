class Engine
	
	constructor: () ->
		@last_frame_time   = null
		@camera            = null
		@scene             = new THREE.Scene()
		@renderer          = new THREE.WebGLRenderer()
		@block_size        = 1
		@ball              = null
		@ball_radius       = @block_size * 0.15
		@keyboard          = new THREEx.KeyboardState()
		@current_action     = null
		@action_remaining  = null
		@camera_offset     = null
		@highlight         = null
		@surface_highlight = null
		@debug             = false	
		@viewport_x        = null
		@viewport_y        = null
		@entities          = []
		@particleSystems   = []
		# Used for rotating upwards
		@player_up_temp      = null
		@player_forward_temp = null

	init: () ->
		# Initialise viewport and renderer
		viewport    = $('#game')
		@viewport_x = viewport.width()
		@viewport_y = window.innerHeight - viewport.position().top - 20
		@renderer.setSize @viewport_x, @viewport_y
		viewport.append @renderer.domElement
		
		# Add scene elements
		Player.addToScene @scene
		Level.addToScene  @scene
		
		# Create ball
		texture           = THREE.ImageUtils.loadTexture(Level.ball_texture)
		texture.minFilter = THREE.LinearFilter
		texture.magFilter = THREE.NearestFilter
		ball_material     = new THREE.MeshBasicMaterial({map: texture})
		geometry          = new THREE.SphereGeometry(@ball_radius, 16, 16)
		@ball             = new THREE.Mesh( geometry, ball_material )
		@ball.position.y  = @block_size/2 + @ball_radius
		Player.rotation.add @ball
		
		# Debug info
		if @debug
			# Current surface (shown as wireframe ball)
			geometry = new THREE.SphereGeometry(@ball_radius*1.1, 16, 16)
			material = new THREE.MeshBasicMaterial({wireframe: true, color: 0xFF0000})
			@surface_highlight = new THREE.Mesh( geometry, material )
			@scene.add @surface_highlight
			# Current block
			geometry = new THREE.CubeGeometry( @block_size*1.01, @block_size*1.01, @block_size*1.01 )
			material = new THREE.MeshBasicMaterial({wireframe: true})
			@highlight = new THREE.Mesh( geometry, material )
			@scene.add @highlight
			# Update
			Utility.update_debug_info()
		
		# Position camera
		@camera = new THREE.PerspectiveCamera( 75, @viewport_x/@viewport_y, 0.1, 20000 )
		@camera.position = @ball.position.clone().addSelf(Player.up.clone().multiplyScalar(@block_size*0.5)).addSelf(Player.forward.clone().multiplyScalar(@block_size*-0.8))
		@camera.lookAt @ball.position.clone().addSelf(Player.up.clone().multiplyScalar(@ball_radius * 2))
		Player.rotation.add @camera
		
	executeActions: () ->
		if @current_action
			# Work out how much of the action to perform this frame
			action_proportion_this_frame = @ms_since_last_frame / 250
			if @action_proportion_remaining < action_proportion_this_frame
				action_proportion_this_frame = @action_proportion_remaining
			# If there is still anything to do:
			if action_proportion_this_frame > 0
			  # Perform the action
				switch @current_action
					when "forward"
						Player.translate(Player.forward.clone().multiplyScalar(@block_size * action_proportion_this_frame))
						@ball.rotation.x -= @ball_radius;
					when "change_plane_up"
					  # Move player frame
						Player.translate(@player_forward_temp.clone().addSelf(@player_up_temp).multiplyScalar(@block_size * action_proportion_this_frame))
					  # Rotate player frame
						angle = (Math.PI / 2.0) * action_proportion_this_frame
						Player.rotate(Player.right, angle)
					  # Roll
						@ball.rotation.x -= @ball_radius / 2
					when "change_plane_down"
					  # Rotate player frame
						angle = -(Math.PI / 2.0) * action_proportion_this_frame
						Player.rotate(Player.right, angle)
					  # Roll
						@ball.rotation.x -= @ball_radius
					when "turn_left"
					  # Rotate player frame
						angle = (Math.PI / 2.0) * action_proportion_this_frame
						Player.rotate(Player.up, angle)
					when "turn_right"
					  # Rotate player frame
						angle = -(Math.PI / 2.0) * action_proportion_this_frame
						Player.rotate(Player.up, angle)
					when "turn_around"
					  # Rotate player frame
						angle = Math.PI * action_proportion_this_frame
						Player.rotate(Player.up, angle)
					when "jump"
						@ball.position.y += (@block_size / 2) * (@action_proportion_remaining - 0.5)
					when "jump_forward"
						Player.translate(Player.forward.clone().multiplyScalar(@block_size * 2 * action_proportion_this_frame))
						@ball.rotation.x -= @ball_radius;
						@ball.position.y += (@block_size / 2) * (@action_proportion_remaining - 0.5)
				# Decrement action step
				@action_proportion_remaining -= action_proportion_this_frame
		  # Action has been completed
			if @action_proportion_remaining <= 0
			  Utility.update_debug_info()
			  # Round off vectors
			  Utility.makeInteger(Player.right)
			  Utility.makeInteger(Player.up)
			  Utility.makeInteger(Player.forward)
			  if @debug
			    Utility.logVector("rght", Player.right)
			    Utility.logVector("up", Player.up)
			    Utility.logVector("fwd", Player.forward)
			  # clear current action
			  @current_action = null;
						
	detectUserInput: () ->
		if @current_action == null
			# Move forward
			if @keyboard.pressed("up")
				# Are we jumping forward?
				if @keyboard.pressed("space")
					@current_action = "jump_forward"
				else
			    # Check if we are allowed to go forward
					if Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward)) && 
						!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up))
			      @current_action = "forward";
					else if Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up)) && 
						!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up).addSelf(Player.right)) && 
						!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up).subSelf(Player.right))
			      @current_action = "change_plane_up";
			      @player_up_temp = Player.up.clone();
			      @player_forward_temp = Player.forward.clone();
					else if !Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up)) && 
						!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward)) && 
						!Level.isBlockAt(Player.current_block.clone().addSelf(Player.right)) && 
						!Level.isBlockAt(Player.current_block.clone().subSelf(Player.right))
			      @current_action = "change_plane_down";
			# Turn left
			else if @keyboard.pressed("left")
			  @current_action = "turn_left";
			# Turn right
			else if @keyboard.pressed("right")
			  @current_action = "turn_right";
			# Turn around
			else if @keyboard.pressed("down")
			  @current_action = "turn_around";
			# Jump in place
			else if @keyboard.pressed("space")
			  @current_action = "jump";
			# Initialise action remaining counter
			if @current_action
				@action_proportion_remaining = 1.0;
				if @debug
					Utility.log(@current_action);				
	
	animate: () ->
		# Get elapsed time since last frame
		current_time = new Date().getTime();
		@ms_since_last_frame = current_time - @last_frame_time;
		@last_frame_time= current_time;

		# Run current action if any
		this.executeActions()

		# Update player position
		Player.updateCurrentPosition()

		# Animate entities
		for entity of @entities
		 	@entities[entity].animate()

		# Make ball breathe
		ball_v_scale = (Math.sin(current_time/300) * 0.025);
		@ball.scale.set(1,0.9 + ball_v_scale,1)
		@ball.position.y = @block_size/2 + @ball_radius + (ball_v_scale*@ball_radius)

		# Check all entities for collisions
		for entity of @entities
			# collide will return true if we should remove the collided-with object and carry on
			if @entities[entity].collide(Player.current_block, Player.current_surface)
				# Fire pickup animation
				pickup = new EntityPickup(@entities[entity]);
				# Remove entity from array and scene
				@entities[entity].removeFromScene(@scene);
				@entities.splice(entity, 1);
				# Adjust counter for removed item
				entity -= 1;

		# Detect keyboard presses
		this.detectUserInput()

		# Render
		@renderer.render @scene, @camera
		
window.Engine = new Engine