class Utility
	
	makeInteger: (vector) ->
	  vector.x = Math.floor(vector.x + 0.5)
	  vector.y = Math.floor(vector.y + 0.5)
	  vector.z = Math.floor(vector.z + 0.5)

	logVector: (name, vector) ->
	  log name + ": " + vector.x + "," + vector.y + "," + vector.z

	log: (string) ->
	  $("#log").prepend string + "<br/>"

	update_debug_info: ->
	  return  unless debug
	  highlight.position = current_block
	  surface_highlight.position = current_block.clone().addSelf(Player.up.clone().multiplyScalar(0.85))

	render: ->
	  renderer.render scene, camera
  
window.Utility = new Utility