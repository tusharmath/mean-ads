ProgramController = require '../backend/controllers/ProgramController'
BaseController = require '../backend/controllers/BaseController'
{Injector} = require 'di'

describe 'ProgramController:', ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get ProgramController
	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
