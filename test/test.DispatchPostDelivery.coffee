DispatchPostDelivery = require '../backend/modules/DispatchPostDelivery'
SubscriptionPopulator = require '../backend/modules/SubscriptionPopulator'
DispatchFactory = require '../backend/factories/DispatchFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
DateProvider = require '../backend/providers/DateProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{mockDataSetup} = require './mocks/MockData'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'

_json = (obj) ->
	JSON.parse JSON.stringify obj
describe 'DispatchPostDelivery:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# DispatchPostDelivery
		@mod = @injector.get DispatchPostDelivery
		@mod.Models = {}

		#SubscriptionPopulator
		@subPopulator =  @injector.get SubscriptionPopulator

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		# DateProvider
		@date = @injector.get DateProvider

		#ModelFactory
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.models()

		#DispatchFactory
		@dispatchFac = @injector.get DispatchFactory

		#Mock Data
		@mockDataSetup = mockDataSetup

	afterEach ->
		@mongo.__reset()

	describe "_increaseUsedCredits()", ->
		beforeEach ->
			@mockDataSetup()
			.then =>
				@Models.Subscription
				.findByIdAndUpdate @subscription._id, usedCredits: 100
				.execQ()
			.then =>
				@subPopulator.populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "updates used credits", ->
			@mod._increaseUsedCredits @subscriptionP, 20
			.should.eventually.have.property 'usedCredits'
			.equal 120

		it "ignore credits if pricing isnt CPM", ->
			@subscriptionP.campaign.program.pricing = "CPA"
			@mod._increaseUsedCredits @subscriptionP, 20
			.should.eventually.have.property 'usedCredits'
			.equal 100
		it "increases impressions", ->
			@mod._increaseUsedCredits @subscriptionP
			.should.eventually.have.property 'impressions'
			.equal 1001

	describe "_updateDeliveryDate()", ->
		beforeEach ->
			@mockDataSetup()
			.then => @dispatchFac.createForSubscriptionId @subscription._id
			.then (@dispatch) => @dispatch.update lastDeliveredOn: new Date 10, 10, 10

		it "updates delivery date", ->
			@mod._updateDeliveryDate @dispatch
			.then => @dispatch.lastDeliveredOn.should.be.greaterThan new Date 10, 10, 10

	describe "delivered()", ->
		beforeEach ->
			sinon.stub @mod, '_getSubscriptionCost'
			.returns 35
			@mockDataSetup()
			.then => @dispatchFac.createForSubscriptionId @subscription._id
			.then (@dispatch) =>

		it "updates used credits of subscription", ->
			initialCredits = @subscription.usedCredits
			@mod.delivered @dispatch
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'usedCredits'
			.to.equal initialCredits + 35

		it "updates last delivery date of dispatch", ->
			sinon.spy @mod, '_updateDeliveryDate'
			@mod.delivered @dispatch
			.then => @mod._updateDeliveryDate.called.should.be.ok
		### TODO: Remove subscriptions dont expire
		it "removes expired subscriptions", ->
			sinon.stub @utils, 'hasSubscriptionExpired'
			.returns yes
			@mod.delivered @dispatch
			.then => @Models.Dispatch.findByIdQ @dispatch._id
			.should.eventually.equal null
		###
		it "removes exausted subscriptions", ->
			sinon.stub @mod, '_increaseUsedCredits'
			.resolves { hasCredits: no, _id: @subscription._id}
			# sinon.stub @utils, 'hasSubscriptionExpired'
			# .returns no
			@mod.delivered @dispatch
			.then => @Models.Dispatch.findByIdQ @dispatch._id
			.should.eventually.equal null

		### TODO:remove invalid scenario
		it "removes over exausted subscriptions", ->
			sinon.stub @mod, '_increaseUsedCredits'
			.resolves { usedCredits: 101, totalCredits: 100, _id: @subscription._id}
			# sinon.stub @utils, 'hasSubscriptionExpired'
			# .returns no
			@mod.delivered @dispatch
			.then => @Models.Dispatch.findByIdQ @dispatch._id
			.should.eventually.equal null
		###
	describe "_getSubscriptionCost()", ->
		beforeEach ->
			@subscriptionP =
				keywords: ['aa', 'bb', 'cc', 'dd']
				campaign:
					keywordPricing: [
						{keyName: 'aa', keyPrice: 10}
						{keyName: 'bb', keyPrice: 20}
						{keyName: 'dd', keyPrice: 30}
					]
					defaultCost: 100

		it "be a function", ->
			@mod._getSubscriptionCost.should.be.a.function
		it "returns default cost", ->
			@mod._getSubscriptionCost @subscriptionP, 'ee'
			.should.equal 100
			@mod._getSubscriptionCost @subscriptionP
			.should.equal 100
		it "returns price of keyword", ->
			@mod._getSubscriptionCost @subscriptionP, 'aa'
			.should.equal 10
			@mod._getSubscriptionCost @subscriptionP, 'bb'
			.should.equal 20
