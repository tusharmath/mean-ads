Ctor = require '../backend/modules/ControllerFactory'
DbConnectionMock = require './mocks/DbConnectionMock'

describe 'ControllerFactory', ->
	mod = {}
	beforeEach ->
		injector = new di.Injector [DbConnectionMock]
		mod = injector.get Ctor

	it 'should be cool', ->
		mod.should.exist
	it 'should be a promise', ->
		mod.then.should.be.a.Function
