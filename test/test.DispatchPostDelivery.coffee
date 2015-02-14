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
			@mod._increaseUsedCredits @subscriptionP
			.should.eventually.have.property 'usedCredits'
			.equal 101

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
			@mockDataSetup()
			.then => @dispatchFac.createForSubscriptionId @subscription._id
			.then (@dispatch) =>

		it "updates used credits of subscription", ->
			initialCredits = @subscription.usedCredits
			@mod.delivered @dispatch
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'usedCredits'
			.to.equal initialCredits + 1

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