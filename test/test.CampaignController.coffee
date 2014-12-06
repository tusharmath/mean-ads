CampaignController = require '../backend/controllers/CampaignController'
BaseController = require '../backend/controllers/BaseController'
{Injector} = require 'di'

describe 'CampaignController:', ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get CampaignController
	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
	it 'sets the post update hook', ->
		@mod.actions.postUpdateHook.should.equal @mod.postUpdateHook