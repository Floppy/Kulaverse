class Entity
	
	constructor: () ->
		@geometry_code = ""
		@animate_code = ""
		@collide_code = ""
		@object = null
		@position = new THREE.Vector3(0,0,0)
		@frame = new THREE.Object3D()
		@surface = "+Y"
		@pickup = false
	
	addToScene: (scene) ->
		# Get geometry and material set up
		eval @geometry_code
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
		eval @animate_code
		
	# should return true if the object is to be removed from the world
	collide: (position, surface) ->
		if position.equals(@position) && surface == @surface
			eval @collide_code
			# Return whether this item is a pickup or not
			return @pickup
		return false

	removeFromScene: (scene) ->
		scene.remove @frame

window.Entity = Entity