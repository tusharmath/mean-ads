CampaignController = require '../backend/controllers/CampaignController'
BaseController = require '../backend/controllers/BaseController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
{Injector} = require 'di'

describe 'CampaignController:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]
		@mod = @injector.get CampaignController
		@mongo = @injector.getModule 'providers.MongooseProvider', mock: false
	afterEach ->
		@mongo.__reset()
	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
	it 'sets the post update hook', ->
		@mod.actions.postUpdateHook.should.equal @mod.postUpdateHook