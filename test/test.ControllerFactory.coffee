CampaignController = require '../backend/controllers/CampaignController'
ExperimentController = require '../backend/controllers/ExperimentController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]
		@mod = @injector.getModule 'factories.ControllerFactory'
		@mongo = @injector.getModule 'providers.MongooseProvider', mock: false
	afterEach ->
		@mongo.__reset()

	it "contains an instance of Campaign", ->
		@mod.Controllers.Campaign.should.be.an.instanceOf CampaignController
	it "contains an instance of Experiement", ->
		@mod.Controllers.Experiment.should.be.an.instanceOf ExperimentController
