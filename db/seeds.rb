Theme.create(
  :name => 'Cloud',
  :texture_sky => '/assets/clouds.jpg',
  :texture_block => '/assets/block.png',
  :texture_ball => '/assets/ball.png',
)

Entity.create(
  :name => 'Finish',
  :mesh => %q{
    geometry = new THREE.CubeGeometry( 0.25, 0.25, 0.25 );
    material = new THREE.MeshBasicMaterial({wireframe: true});
    mesh = new THREE.Mesh( geometry, material );
  },
  :collide => %q{
    alert('You Win!');
  }
)
