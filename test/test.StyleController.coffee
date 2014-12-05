StyleController = require '../backend/controllers/StyleController'
BaseController = require '../backend/controllers/BaseController'
{Injector} = require 'di'

describe 'StyleController:', ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get StyleController
	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
