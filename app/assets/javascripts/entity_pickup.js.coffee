class EntityPickup
	
	constructor: (entity) ->
		# create the particle variables
		@particleCount = 100
		particles = new THREE.Geometry()
		@material = new THREE.ParticleBasicMaterial({
			color: entity.object.material.color.getHex(),
			size: 0.1,
			map: THREE.ImageUtils.loadTexture(
				"/assets/particle.png"
			),
			blending: THREE.AdditiveBlending,
			transparent: true
	  })
		# now create the individual particles
		for n in [0..@particleCount-1]
			pX = Player.current_block.x + (Player.up.x*(Engine.block_size/2+Engine.ball_radius))
			pY = Player.current_block.y + (Player.up.y*(Engine.block_size/2+Engine.ball_radius))
			pZ = Player.current_block.z + (Player.up.z*(Engine.block_size/2+Engine.ball_radius))
			particle = new THREE.Vertex(
				new THREE.Vector3(pX, pY, pZ)
			)
			particle.velocity = new THREE.Vector3((Math.random() - 0.5)*0.05, (Math.random() - 0.5)*0.05, (Math.random() - 0.5)*0.05)
			# add it to the geometry
			particles.vertices.push(particle)
		# create the particle system
		@particleSystem = new THREE.ParticleSystem(particles, @material)
		@particleSystem.sortParticles = true;
		@age = 0
		# add it to the scene
		Engine.entities.push this
		Engine.scene.add @particleSystem

	collide: () ->
		null

	animate: () ->
		max_age = 1000.0
		@age += Engine.ms_since_last_frame
		@material.opacity = 1 - (@age / max_age)
		for n in [0..@particleCount-1]
			particle = @particleSystem.geometry.vertices[n]
			particle.position.addSelf(particle.velocity);
		@particleSystem.geometry.__dirtyVertices = true
		if @age > max_age
			Engine.scene.remove @particleSystem
			Engine.entities.splice(Engine.entities.indexOf(this), 1)

window.EntityPickup = EntityPickup