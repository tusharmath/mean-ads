ControllerFactory = require '../backend/factories/ControllerFactory'
CampaignController = require '../backend/controllers/CampaignController'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get ControllerFactory
	it "contains an instance of Campaign", ->
		@mod.Controllers.Campaign.should.be.an.instanceOf CampaignController
