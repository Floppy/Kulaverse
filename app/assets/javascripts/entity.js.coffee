class Entity
	
	constructor: () ->
		@geometry_code = ""
		@animate_code = ""
		@collide_code = ""
		@object = null
		@position = new THREE.Vector3(0,0,0)
		@pickup = false
	
	addToScene: (scene) ->
		# Get geometry and material set up
		eval @geometry_code
		# Create mesh object
		@object = new THREE.Mesh( geometry, material );
		# Add to scene
		scene.add @object
		# Set position
		@object.position = @position.clone();
		@object.position.y += 0.75; # Move entites above block, for now, until we have proper idea of which surface it's on.

	animate: () ->
		eval @animate_code
		
	# should return true if the object is to be removed from the world
	collide: (player) ->
		if player.equals(@position)
			eval @collide_code
			# Return whether this item is a pickup or not
			return @pickup
		return false

	removeFromScene: (scene) ->
		scene.remove @object

window.Entity = Entity