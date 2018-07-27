#= require utility
#= require Three

loadFixtures 'log'

describe "Utility", ->
	it "should round off vectors to integers correctly", ->
		vec = new THREE.Vector3(0.9, 0.1, -0.7)
		Utility.makeInteger(vec)
		expect(vec.x).toEqual(1)
		expect(vec.y).toEqual(0)
		expect(vec.z).toEqual(-1)
		
	it "should be able to write to log", ->
		Utility.log	'test'
		Utility.log	'this is a'
		expect($("#log").html()).toEqual("this is a<br/>test<br/>")
		
	it "should be able to write a complete vector to log", ->
		Utility.logVector("test", new THREE.Vector3(0.9, 0.1, -0.7))
		expect($("#log").html()).toEqual("test: 0.9, 0.1, -0.7<br/>")
