CampaignCrud = require '../backend/cruds/CampaignCrud'
Mock = require './mocks'
{Injector} = require 'di'


describe "CampaignCrud", ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get CampaignCrud
		@mod.Models = Subscription: findQ: ->
	describe "_setCampaignKeywords()", ->
		it "be a function",  ->
			@mod._setCampaignKeywords.should.be.a.Function

	describe "postUpdate()", ->
		beforeEach ->
			@mod.Models = Subscription:  findQ: sinon.stub()
			sinon.stub @mod, '_setCampaignKeywords'


		it "be a function", ->
			@mod.postUpdate.should.be.a.Function
		it "calls _setCampaignKeywords", ->
			camp = _id: 1000
			@mod.Models.Subscription.findQ.resolves 'subscriptions-found'
			@mod.postUpdate camp
			.then =>
				@mod._setCampaignKeywords
				.calledWith 'subscriptions-found', camp
				.should.be.ok
		it "calls findQ", ->
			camp = _id: 1000
			@mod.Models.Subscription.findQ.resolves 'subscriptions-found'
			@mod.postUpdate camp
			.then =>
				@mod.Models.Subscription.findQ
				.calledWith campaign: 1000
				.should.be.ok

	describe "_setCampaignKeywords()", ->
		it "be a function",  ->
			@mod._setCampaignKeywords.should.be.a.Function

		it "sets campaignKeywords", ->
			subs = [save:->]
			camp = campaignKeywords: ['q', 'b', 'e']
			@mod._setCampaignKeywords subs, camp
			subs[0].campaignKeywords.should.equal camp.campaignKeywords
		it "saves subscription", ->
			subs = [save:sinon.spy()]
			camp = campaignKeywords: ['q', 'b', 'e']
			@mod._setCampaignKeywords subs, camp
			subs[0].save.called.should.be.ok