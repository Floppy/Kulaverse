class Player

	constructor: ->
		# Set up nested frames
		@position = new THREE.Object3D()
		@rotation = new THREE.Object3D()
		@position.add(@rotation)
		# Initialise player direction
		@forward = new THREE.Vector3(0,0,-1)
		@up      = new THREE.Vector3(0,1,0)
		@right   = new THREE.Vector3(1,0,0)
		# Current location
		@current_block = null
		@current_surface = null
	
	start_at: (x,y,z) ->
		# Initialise player coordinate frame position
		@current_block = new THREE.Vector3(x,y,z)
		@position.position = @current_block.clone().multiplyScalar(Engine.block_size)
		this.updateCurrentSurface()
  
	translate: (vector) ->
		r = new THREE.Matrix4()
		r.setTranslation vector.x, vector.y, vector.z
		@position.applyMatrix r

	rotate: (axis, angle) ->
		r = new THREE.Matrix4()
		r.identity()
		r.setRotationAxis axis, angle
		@right   = r.multiplyVector3 @right
		@up      = r.multiplyVector3 @up
		@forward = r.multiplyVector3 @forward
		@rotation.applyMatrix r

	updateCurrentSurface: () ->
		if @up.x > 0.85
			@current_surface = "+X"
		else if @up.x < -0.85
			@current_surface = "-X"
		else if @up.y > 0.85
			@current_surface = "+Y"
		else if @up.y < -0.85
			@current_surface = "-Y"
		else if @up.z > 0.85
			@current_surface = "+Z"
		else if @up.z < -0.85
			@current_surface = "-Z"

	updateCurrentPosition: () ->
		@current_block.x = Math.floor(@position.position.x + 0.5)
		@current_block.y = Math.floor(@position.position.y + 0.5)
		@current_block.z = Math.floor(@position.position.z + 0.5)
		this.updateCurrentSurface()

	addToScene: (scene) ->
		scene.add @position

window.Player = new Player