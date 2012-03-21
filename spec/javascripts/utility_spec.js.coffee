#= require utility
#= require Three

describe "Utility", ->
	it "should round off vectors to integers correctly", ->
		vec = new THREE.Vector3(0.9, 0.1, -0.7)
		Utility.makeInteger(vec)
		expect(vec.x).toEqual(1)
		expect(vec.y).toEqual(0)
		expect(vec.z).toEqual(-1)