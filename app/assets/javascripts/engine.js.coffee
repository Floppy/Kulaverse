class Engine
	
	constructor: () ->
		@camera            = null
		@scene             = new THREE.Scene()
		@renderer          = new THREE.WebGLRenderer()
		@block_size        = 1
		@ball              = null
		@ball_radius       = @block_size * 0.15
		@keyboard          = new THREEx.KeyboardState()
		@action_status     = null
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
		# Detect keyboard presses unless an action is in progress		
		if @action_status == null
			if @keyboard.pressed("up")
		    # Check if we are allowed to go forward
				if Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward)) && 
					!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up))
		      @action_status = "forward";
		      @action_left = 1.0;
				else if Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up)) && 
					!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up).addSelf(Player.right)) && 
					!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up).subSelf(Player.right))
		      @action_status = "change_plane_up";
		      @player_up_temp = Player.up.clone();
		      @player_forward_temp = Player.forward.clone();
		      @action_left = 1.0;
				else if !Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward).addSelf(Player.up)) && 
					!Level.isBlockAt(Player.current_block.clone().addSelf(Player.forward)) && 
					!Level.isBlockAt(Player.current_block.clone().addSelf(Player.right)) && 
					!Level.isBlockAt(Player.current_block.clone().subSelf(Player.right))
		      @action_status = "change_plane_down";
		      @action_left = 1.0;
			else if @keyboard.pressed("left")
			  @action_status = "turn_left";
			  @action_left = 1.0;
			else if @keyboard.pressed("right")
			  @action_status = "turn_right";
			  @action_left = 1.0;
			else if @keyboard.pressed("down")
			  @action_status = "turn_around";
			  @action_left = 1.0;
			else if @keyboard.pressed("space")
			  @action_status = "jump";
			  @action_left = 1.0;
			if @action_status && @debug
				Utility.log(@action_status);
		else
			# Step 10% per frame
			actionStep = 0.1
		  # Perform the action
			switch @action_status
				when "forward"
					Player.translate(Player.forward.clone().multiplyScalar(@block_size * actionStep))
					@ball.rotation.x -= @ball_radius;
				when "change_plane_up"
				  # Move player frame
					Player.translate(@player_forward_temp.clone().addSelf(@player_up_temp).multiplyScalar(@block_size * actionStep))
				  # Rotate player frame
					angle = (Math.PI / 2.0) * actionStep
					Player.rotate(Player.right, angle)
				  # Roll
					@ball.rotation.x -= @ball_radius / 2
				when "change_plane_down"
				  # Rotate player frame
					angle = -(Math.PI / 2.0) * actionStep
					Player.rotate(Player.right, angle)
				  # Roll
					@ball.rotation.x -= @ball_radius
				when "turn_left"
				  # Rotate player frame
					angle = (Math.PI / 2.0) * actionStep
					Player.rotate(Player.up, angle)
				when "turn_right"
				  # Rotate player frame
					angle = -(Math.PI / 2.0) * actionStep
					Player.rotate(Player.up, angle)
				when "turn_around"
				  # Rotate player frame
					angle = Math.PI * actionStep
					Player.rotate(Player.up, angle)
				when "jump"
					@ball.position.y += (@block_size / 2) * (@action_left - 0.55)
			# Decrement action step
			@action_left -= actionStep
		  # If this is the end
			if @action_left <= actionStep
			  Utility.update_debug_info();
			  # Round off vectors
			  Utility.makeInteger(Player.right);
			  Utility.makeInteger(Player.up);
			  Utility.makeInteger(Player.forward);
			  if @debug
			    Utility.logVector("rght", Player.right);
			    Utility.logVector("up", Player.up);
			    Utility.logVector("fwd", Player.forward);
			  # clear action status
			  @action_status = null;
			  @action_left = 0;

		# Animate entities
		for entity of @entities
		 	@entities[entity].animate();

		# Update current block
		previous_block = Player.current_block.clone();
		Player.current_block.x = Math.floor(Player.position.position.x + 0.5);
		Player.current_block.y = Math.floor(Player.position.position.y + 0.5);
		Player.current_block.z = Math.floor(Player.position.position.z + 0.5);

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

		# Render
		@renderer.render @scene, @camera
		
window.Engine = new Engine