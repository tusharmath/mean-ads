CampaignController = require '../backend/controllers/CampaignController'
ExperimentController = require '../backend/controllers/ExperimentController'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.getModule 'factories.ControllerFactory'
	it "contains an instance of Campaign", ->
		@mod.Controllers.Campaign.should.be.an.instanceOf CampaignController
	it "contains an instance of Experiement", ->
		@mod.Controllers.Experiment.should.be.an.instanceOf ExperimentController
