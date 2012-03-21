class Player

	constructor: ->
		# Set up nested frames
		@position = new THREE.Object3D();
		@rotation = new THREE.Object3D();
		@position.add(@rotation);
		# Initialise player direction
		@forward = new THREE.Vector3(0,0,-1);
		@up      = new THREE.Vector3(0,1,0);
		@right   = new THREE.Vector3(1,0,0);
	
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

	addToScene: (scene) ->
		scene.add @position

window.Player = new Player