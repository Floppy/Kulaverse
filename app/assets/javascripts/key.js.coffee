class Key
	
	constructor: () ->
		@object = null
		@position = new THREE.Vector3(0,0,0)
		@frame = new THREE.Object3D()
		@surface = "+Y"
		@pickup = true
	
	addToScene: (scene) ->
		# Get geometry and material set up
		geometry = new THREE. CubeGeometry(0.05, 0.05, 0.2, 1, 1, 1 )
		material = new THREE.MeshLambertMaterial({color: 0xFFFF00})
		# Create mesh object
		@object = new THREE.Mesh( geometry, material );
		# Add to scene
		@frame.add @object
		scene.add @frame
		# Set frame
		@frame.position = @position.clone();
		# Rotate frame
		switch @surface
			when "+X"
				@frame.rotation.z = -Math.PI/2;
			when "-X"
				@frame.rotation.z = Math.PI/2;
			when "+Y"
				null
			when "-Y"
				@frame.rotation.x = Math.PI;
			when "+Z"
				@frame.rotation.x = Math.PI/2;
			when "-Z"
				@frame.rotation.x = -Math.PI/2;
		# Lift entity out of block
		@object.position.y += 0.75
		# Need another key to exit
		Level.keys_required += 1
		Level.updateKeyDisplay()

	animate: () ->
		@object.eulerOrder = 'YXZ'
		@object.rotation.y += 0.02
		@object.rotation.x = Math.PI/2
	
	# should return true if the object is to be removed from the world
	collide: (position, surface) ->
		if position.equals(@position) && surface == @surface
			Level.getKey()
			Level.addScore 100
			# Return whether this item is a pickup or not
			return @pickup
		return false

	removeFromScene: (scene) ->
		scene.remove @frame

window.Key = Key