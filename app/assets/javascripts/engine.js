var camera, scene, renderer, ball, ball_radius, keyboard, action_status, action_remaining, camera_offset;
var block_size;
var highlight;
var surface_highlight;
var debug = false;
var viewport_x, viewport_y;
var entities = [];

// Used for rotating upwards
var player_up_temp = null;
var player_forward_temp = null;

function init() {
		
	// Set up some global variables
	action_status = null;
	block_size = 1;
	ball_radius = block_size * 0.15;

	// Set up keyboard input
	keyboard = new THREEx.KeyboardState();

	// Create scene
	scene = new THREE.Scene();

	// Initialise viewport and renderer
	var viewport = $('#game');
	renderer = new THREE.WebGLRenderer();
	viewport_x = viewport.width();
	viewport_y = window.innerHeight - viewport.position().top - 20;
	renderer.setSize( viewport_x, viewport_y );
	viewport.append( renderer.domElement );

}

function animate() {

  // note: three.js includes requestAnimationFrame shim
  requestAnimationFrame(animate);

  if (action_status == null) {
    // Detect keyboard presses unless an action is in progress
    if (keyboard.pressed("up")) {
      // Check if we are allowed to go forward
      if (Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)) && !Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)
        .addSelf(Player.up))) {
        action_status = "forward";
        action_left = 1.0;
      } else if (Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)
        .addSelf(Player.up)) && !Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)
        .addSelf(Player.up)
        .addSelf(Player.right)) && !Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)
        .addSelf(Player.up)
        .subSelf(Player.right))) {
        action_status = "change_plane_up";
        player_up_temp = Player.up.clone();
        player_forward_temp = Player.forward.clone();
        action_left = 1.0;
      } else if (!Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)
        .addSelf(Player.up)) && !Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.forward)) && !Level.isBlockAt(Player.current_block.clone()
        .addSelf(Player.right)) && !Level.isBlockAt(Player.current_block.clone()
        .subSelf(Player.right))) {
        action_status = "change_plane_down";
        action_left = 1.0;
      }
    } else if (keyboard.pressed("left")) {
      action_status = "turn_left";
      action_left = 1.0;
    } else if (keyboard.pressed("right")) {
      action_status = "turn_right";
      action_left = 1.0;
    } else if (keyboard.pressed("down")) {
      action_status = "turn_around";
      action_left = 1.0;
    } else if (keyboard.pressed("space")) {
      action_status = "jump";
      action_left = 1.0;
    }
    if (action_status && debug) log(action_status);
  } else {
    // Step 10% per frame
    actionStep = 0.1
    // Perform the action
    if (action_status == "forward") {
      Player.translate(Player.forward.clone()
        .multiplyScalar(block_size * actionStep));
      ball.rotation.x -= ball_radius;
    } else if (action_status == "change_plane_up") {
      // Move player frame
      Player.translate(player_forward_temp.clone()
        .addSelf(player_up_temp)
        .multiplyScalar(block_size * actionStep));
      // Rotate player frame
      angle = (Math.PI / 2.0) * actionStep;
      Player.rotate(Player.right, angle);
      // Roll
      ball.rotation.x -= ball_radius / 2;
    } else if (action_status == "change_plane_down") {
      // Rotate player frame
      angle = -(Math.PI / 2.0) * actionStep;
      Player.rotate(Player.right, angle);
      // Roll
      ball.rotation.x -= ball_radius;
    } else if (action_status == "turn_left") {
      // Rotate player frame
      angle = (Math.PI / 2.0) * actionStep;
      Player.rotate(Player.up, angle);
    } else if (action_status == "turn_right") {
      // Rotate player frame
      angle = -(Math.PI / 2.0) * actionStep;
      Player.rotate(Player.up, angle);
    } else if (action_status == "turn_around") {
      // Rotate player frame
      angle = Math.PI * actionStep;
      Player.rotate(Player.up, angle);
    } else if (action_status == "jump") {
      ball.position.y += (block_size / 2) * (action_left - 0.55);
    }
    action_left -= actionStep;
    // If this is the end
    if (action_left <= actionStep) {
      Utility.update_debug_info();
      // Round off vectors
      Utility.makeInteger(Player.right);
      Utility.makeInteger(Player.up);
      Utility.makeInteger(Player.forward);
      if (debug) {
        Utility.logVector("rght", Player.right);
        Utility.logVector("up", Player.up);
        Utility.logVector("fwd", Player.forward);
      }
      // clear action status
      action_status = null;
      action_left = 0;
    }
  }

  // Animate entities
  for (entity in entities) {
    entities[entity].animate();
  }

  // Update current block
  previous_block = Player.current_block.clone();
  Player.current_block.x = Math.floor(Player.position.position.x + 0.5);
  Player.current_block.y = Math.floor(Player.position.position.y + 0.5);
  Player.current_block.z = Math.floor(Player.position.position.z + 0.5);

  // If block has changed
  if (Player.current_block.x != previous_block.x || Player.current_block.y != previous_block.y || Player.current_block.z != previous_block.z) {
    // Check for collisions
    for (entity in entities) {
      if (entities[entity].collide(Player.current_block)) {
        // Remove entity from array and scene
        entities[entity].removeFromScene(scene);
        entities.splice(entity, 1);
        // Adjust counter for removed item
        entity -= 1;
      }
    }
  }

  Utility.render();

}
