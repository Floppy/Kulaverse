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
		@camera.position = @ball.position.clone().addSelf(Player.up.clone().multiplyScalar(0.5)).addSelf(Player.forward.clone().multiplyScalar(-0.8))
		@camera.lookAt @ball.position.clone().addSelf(Player.up.clone().multiplyScalar(@ball_radius * 2))
		Player.rotation.add @camera
		
	animate: () ->
		# Get elapsed time since last frame
		current_time = new Date().getTime();
		@ms_since_last_frame = current_time - @last_frame_time;
		@last_frame_time= current_time;

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
						@ball.position.y += (@block_size / 2) * (@action_proportion_remaining - 0.55)
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

		# Animate entities
		for entity of @entities
		 	@entities[entity].animate()

		# Update current block
		previous_block = Player.current_block.clone()
		Player.current_block.x = Math.floor(Player.position.position.x + 0.5)
		Player.current_block.y = Math.floor(Player.position.position.y + 0.5)
		Player.current_block.z = Math.floor(Player.position.position.z + 0.5)

		# If block has changed
		if Player.current_block.x != previous_block.x || Player.current_block.y != previous_block.y || Player.current_block.z != previous_block.z
		  # Check for collisions
		  for entity of @entities
		    if @entities[entity].collide(Player.current_block)
		      # Remove entity from array and scene
		      @entities[entity].removeFromScene(@scene);
		      @entities.splice(entity, 1);
		      # Adjust counter for removed item
		      entity -= 1;

		# Detect keyboard presses unless an action is still in progress		
		if @current_action == null
			if @keyboard.pressed("up")
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
			else if @keyboard.pressed("left")
			  @current_action = "turn_left";
			else if @keyboard.pressed("right")
			  @current_action = "turn_right";
			else if @keyboard.pressed("down")
			  @current_action = "turn_around";
			else if @keyboard.pressed("space")
			  @current_action = "jump";
			# Initialise action remaining counter
			if @current_action
				@action_proportion_remaining = 1.0;
				if @debug
					Utility.log(@current_action);

		# Render
		@renderer.render @scene, @camera
		
window.Engine = new Engine