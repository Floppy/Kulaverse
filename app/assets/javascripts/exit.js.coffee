class Exit
	
	constructor: () ->
		@object = null
		@position = new THREE.Vector3(0,0,0)
		@frame = new THREE.Object3D()
		@surface = "+Y"
		@pickup = false
	
	addToScene: (scene) ->
		# Get geometry and material set up
		geometry = new THREE.TextGeometry( 'EXIT', {font: 'helvetiker', size: 0.2, height: 0.1} )
		material = new THREE.MeshLambertMaterial({color: 0x7F0000, opacity: 0.25})
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
		@object.position.y += 0.75;

	animate: () ->
		this.object.rotation.y += 0.02;
		if Level.gotAllKeys()
		  material = new THREE.MeshLambertMaterial({color: 0x007F00})
		  this.object.material = material
		
	# should return true if the object is to be removed from the world
	collide: (position, surface) ->
		if position.equals(@position) && surface == @surface
			levelComplete()
			# Return whether this item is a pickup or not
			return @pickup
		return false

	removeFromScene: (scene) ->
		scene.remove @frame

window.Exit = Exit