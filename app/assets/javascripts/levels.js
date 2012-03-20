function isBlockAt(vector) {
	 if (debug)
	 	log("block query "+vector.x+","+vector.y+","+vector.z+": " + (block_list[vector.x+":"+vector.y+":"+vector.z] != null));
	return block_list[vector.x+":"+vector.y+":"+vector.z];
}
	
function makeInteger(vector) {
	vector.x = Math.floor(vector.x+0.5);
	vector.y = Math.floor(vector.y+0.5);
	vector.z = Math.floor(vector.z+0.5);
}
	
function logVector(name, vector) {
	log(name + ": " + vector.x + "," + vector.y + "," + vector.z);
}

function translatePlayer(vector) {
	r = new THREE.Matrix4();
	r.setTranslation(vector.x, vector.y, vector.z);
	player_pos.applyMatrix(r);
}

function rotatePlayer(axis, angle) {
	r = new THREE.Matrix4();
	r.identity();
	r.setRotationAxis(axis, angle);
	player_right = r.multiplyVector3(player_right);
	player_up = r.multiplyVector3(player_up);
	player_forward = r.multiplyVector3(player_forward);
	player_rot.applyMatrix(r);
}

function levelComplete() {
	log("LEVEL COMPLETE");
}
	
function log(string) {
	$("#log").prepend(string+'<br/>');
}

function update_debug_info()
{
	if (!debug)
		return;
	// Update highlight
	highlight.position = current_block;
	surface_highlight.position = current_block.clone().addSelf(player_up.clone().multiplyScalar(0.85));
}

function render() {
	// Render scene
    renderer.render( scene, camera );
}

function addScore(value) {
	log("scored "+value);
	$("#score").html(parseInt($("#score").html())+value)
}
