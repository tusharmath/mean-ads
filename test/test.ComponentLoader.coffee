ComponentLoader = require '../backend/modules/ComponentLoader'
di = require 'di'

describe 'ComponentLoader', ->
	loader = {}
	beforeEach ->
		injector = new di.Injector()
		loader = injector.get ComponentLoader

	describe 'load()', ->
		it 'should exist', ->
			loader.load.should.be.a.Function
