SubscriptionCrud = require '../backend/cruds/SubscriptionCrud'
{Injector} = require 'di'
describe "SubscriptionCrud", ->
	beforeEach ->
		injector = new Injector
		@mod = injector.get SubscriptionCrud

	describe "_updateSubscription()", ->
		beforeEach ->
			@subscription = {}
			@campaign =
				program: 123312
				keywords: [1,2,3,4]
				days: 37


		it "returns subscription", ->
			@mod._updateSubscription @subscription, @campaign
			.should.equal @subscription

		it "sets program", ->
			@mod._updateSubscription @subscription, @campaign
			.program.should.equal 123312

		it "sets keywords", ->
			@mod._updateSubscription @subscription, @campaign
			.keywords.should.eql [1,2,3,4]

		it "sets end date", ->
			@mod._updateSubscription @subscription, @campaign
			.endDate.should.be.a 'Date'

		it "sets end date as now + campaign days", ->
			expiryDate = new Date
			expiryDate.setDate expiryDate.getDate() + @campaign.days
			@mod._updateSubscription @subscription, @campaign
			.endDate.should.eql expiryDate

	describe "preCreate()", ->
		beforeEach ->
			@campaign = 'qwerwe'
			@mod.Models = Campaign: findByIdQ : sinon.stub().resolves @campaign
		it "be a function",  -> @mod.preCreate.should.be.a.Function
		it "calls findByIdQ", ->
			subscription = campaign: 1000
			@mod.preCreate subscription
			.then =>
				@mod.Models.Campaign.findByIdQ
				.calledWith 1000
				.should.be.ok

		it "resolves subcriptions", ->

			sinon.stub @mod, '_updateSubscription', (s, c) -> "#{s}~~~#{c}"
			@mod.preCreate 'asdgdf'
			.should.eventually.equal 'asdgdf~~~qwerwe'