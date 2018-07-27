class Utility
	
	makeInteger: (vector) ->
	  vector.x = Math.floor(vector.x + 0.5)
	  vector.y = Math.floor(vector.y + 0.5)
	  vector.z = Math.floor(vector.z + 0.5)

	logVector: (name, vector) ->
	  this.log name + ": " + vector.x + "," + vector.y + "," + vector.z

	log: (string) ->
	  $("#log").prepend string + "<br/>"

	update_debug_info: ->
	  return  unless Engine.debug
	  Engine.highlight.position = Player.current_block
	  Engine.surface_highlight.position = Player.current_block.clone().addSelf(Player.up.clone().multiplyScalar(0.85))

window.Utility = new Utility