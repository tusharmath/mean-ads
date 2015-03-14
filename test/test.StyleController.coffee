StyleController = require '../backend/controllers/StyleController'
BaseController = require '../backend/controllers/BaseController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
{Injector} = require 'di'

describe 'StyleController:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]
		@Models = @injector.getModule 'factories.ModelFactory', mock: false
		@mod = @injector.get StyleController
	afterEach ->
		@Models.mongooseP.__reset()

	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
	it 'sets the post update hook', ->
		@mod.actions.postUpdateHook.should.equal @mod.postUpdateHook