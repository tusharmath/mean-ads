SubscriptionCrud = require '../backend/cruds/SubscriptionCrud'
{Injector} = require 'di'
describe "SubscriptionCrud", ->
	beforeEach ->
		injector = new Injector
		@mod = injector.get SubscriptionCrud

	describe "preCreate()", ->
		beforeEach ->
			@campaign = program: 120, keywords: ['a', 'bb', 'ccc']
			@mod.Models = Campaign: findByIdQ : sinon.stub().resolves @campaign
		it "be a function",  -> @mod.preCreate.should.be.a.Function
		it "calls findByIdQ", ->
			subscription = campaign: 1000
			@mod.preCreate subscription
			.then =>
				@mod.Models.Campaign.findByIdQ
				.calledWith 1000
				.should.be.ok

		it "sets set campaign data", ->
			subscription = {}
			@mod.preCreate subscription
			.should.eventually.be.eql(
				campaignProgramId: 120
				campaignKeywords: ['a', 'bb', 'ccc']
				)


