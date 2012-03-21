class Level
	
	constructor: () ->
		@block_list = {}
		@block_texture = ""
		
	addBlocks: (blocks) ->
		this.addBlock block for block in blocks

	addBlock: (block) ->
		@block_list["#{block[0]}:#{block[1]}:#{block[2]}"] = block;
		
	addToScene: (scene) ->
		# Create cube
		geometry = new THREE.CubeGeometry(block_size, block_size, block_size)
		# Set up texture
		texture = THREE.ImageUtils.loadTexture(@block_texture)
		texture.minFilter = THREE.LinearFilter
		texture.magFilter = THREE.NearestFilter
		# Create material using texture
		material = new THREE.MeshBasicMaterial(map: texture)
		# Create blocks
		for block of @block_list
		  mesh = new THREE.Mesh(geometry, material)
		  mesh.position.x = @block_list[block][0] * block_size
		  mesh.position.y = @block_list[block][1] * block_size
		  mesh.position.z = @block_list[block][2] * block_size
		  scene.add mesh
			
	isBlockAt: (vector) ->
	  Utility.log "block query #{vector.x},#{vector.y},#{vector.z}: " + (@block_list["#{vector.x}:#{vector.y}:#{vector.z}"]?)  if debug
	  @block_list["#{vector.x}:#{vector.y}:#{vector.z}"]

	levelComplete: ->
	  Utility.log "LEVEL COMPLETE"

	addScore: (value) ->
	  Utility.log "scored " + value if debug
	  $("#score").html parseInt($("#score").html()) + value

window.Level = new Level