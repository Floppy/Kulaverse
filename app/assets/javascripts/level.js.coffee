class Level
	
	constructor: () ->
		@block_list = {}
		@block_texture = ""
		@entities = []
		@sky_texture = ""
		@score = 0
		@keys_required = 0
		@keys_obtained = 0
		
	addBlocks: (blocks) ->
		this.addBlock block for block in blocks

	addBlock: (block) ->
		@block_list["#{block[0]}:#{block[1]}:#{block[2]}"] = block;
		
	addToScene: (scene) ->
    # Add skybox
		sky_material = new THREE.MeshBasicMaterial(map: THREE.ImageUtils.loadTexture(@sky_texture))
		geometry = new THREE.SphereGeometry(18000, 16, 16)
		sky = new THREE.Mesh( geometry, sky_material )
		sky.scale.y = -1
		scene.add sky
		# Create cube
		geometry = new THREE.CubeGeometry(Engine.block_size, Engine.block_size, Engine.block_size)
		# Set up texture
		texture = THREE.ImageUtils.loadTexture(@block_texture)
		texture.minFilter = THREE.LinearFilter
		texture.magFilter = THREE.NearestFilter
		# Create material using texture
		material = new THREE.MeshBasicMaterial(map: texture)
		# Create blocks
		for block of @block_list
		  mesh = new THREE.Mesh(geometry, material)
		  mesh.position.x = @block_list[block][0] * Engine.block_size
		  mesh.position.y = @block_list[block][1] * Engine.block_size
		  mesh.position.z = @block_list[block][2] * Engine.block_size
		  scene.add mesh
		# Add entities
		for entity of @entities
		  @entities[entity].addToScene(scene);
		  Engine.entities.push(@entities[entity]);
		
			
	isBlockAt: (vector) ->
	  Utility.log "block query #{vector.x},#{vector.y},#{vector.z}: " + (@block_list["#{vector.x}:#{vector.y}:#{vector.z}"]?)  if Engine.debug
	  @block_list["#{vector.x}:#{vector.y}:#{vector.z}"]

	addScore: (value) ->
	  Utility.log "scored " + value if Engine.debug
	  @score += value
	  $("#score").html @score
	  
	getKey: ->
	  Utility.log "picked up key" if Engine.debug
	  @keys_obtained += 1
	  this.updateKeyDisplay()
	  
	gotAllKeys: ->
	  @keys_obtained == @keys_required
	  
	updateKeyDisplay: ->
	  Utility.log "required: #{@keys_required}" if Engine.debug
	  Utility.log "obtained: #{@keys_obtained}" if Engine.debug
	  html = ''
	  for i in [0...@keys_obtained]
		  html += '<i class="icon-ok"></i> '
	  for i in [0...(@keys_required - @keys_obtained)]
		  html += '<i class="icon-lock"></i> '		
	  $("#keys").html html
	  
window.Level = new Level