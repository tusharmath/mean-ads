BaseController = require '../backend/controllers/BaseController'
Mock = require './mocks'
{Injector} = require 'di'


describe 'BaseController:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get BaseController

	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseController