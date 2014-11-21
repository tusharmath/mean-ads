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

		it "throws errors if _id is not present", ->
			camp = {}
			expect => @mod.postUpdate camp
			.to.throw 'Campaign must have [_id] field'


	describe "_keywordUpdateMapper()", ->
		it "be a function", ->
			@mod._keywordUpdateMapper.should.be.a.Function
		it 'updates sub', ->
			sub  = updateQ: sinon.spy()
			camp = keywords: [1,2,3,4]
			@mod._keywordUpdateMapper sub, camp
			sub.updateQ.calledWith keywords: camp.keywords, program: camp.program
			.should.be.ok
		it 'resolves', ->
			sub  = updateQ: sinon.stub().resolves 123321
			camp = keywords: [1,2,3,4]
			@mod._keywordUpdateMapper sub, camp
			.should.eventually.equal 123321


	describe "_setCampaignKeywords()", ->
		it "be a function",  ->
			@mod._setCampaignKeywords.should.be.a.Function
		it 'resolves a map', ->
			subs = [1,2,3,4]
			camp = 20
			@mod._keywordUpdateMapper = (sub, camp) -> sub * camp
			@mod._setCampaignKeywords subs, camp
			.should.eventually.eql [20, 40, 60, 80]