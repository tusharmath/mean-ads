Dispatcher = require '../backend/modules/Dispatcher'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
DateProvider = require '../backend/providers/DateProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{mockDataSetup} = require './mocks/MockData'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'
DispatchPostDelivery = require '../backend/modules/DispatchPostDelivery'
DispatchFactory = require '../backend/factories/DispatchFactory'

_json = (obj) ->
	JSON.parse JSON.stringify obj
describe 'Dispatcher:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# Dispatcher
		@mod = @injector.get Dispatcher
		@mod.Models = {}

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		# DateProvider
		@date = @injector.get DateProvider

		#ModelFactory
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.models()

		#Mock Data
		@mockDataSetup = mockDataSetup

		#DispatchPostDelivery
		@mockPromise = done: sinon.spy()
		@dispatchDelivery = @injector.get DispatchPostDelivery
		sinon.stub @dispatchDelivery, 'delivered'
		.returns @mockPromise

		#DispatchFactory
		@dispatchFac = @injector.get DispatchFactory

	afterEach ->
		@mongo.__reset()

	describe "next()", ->
		beforeEach ->
			# Stubbing the Current date
			sinon.stub @date, 'now'
			.returns new Date 2014, 1, 2

			# Fake dispatch
			@mockDataSetup()
			.then =>
				dispatch =
					markup: 'hello world'
					subscription: @subscription._id
					program : @program._id
					startDate: new Date 2014, 1, 1
					keywords: ['aa', 'bb']
				@Models.Dispatch(dispatch).saveQ()
			.then (@dispatch)=>

		it "queries by program id", ->
			@mod.next @program._id
			.should.eventually.have.property 'markup'
			.equal "hello world"

		it "queries null with keywords", ->
			@mod.next @program._id, ['cc']
			.should.eventually.equal null
		it "queries with keywords", ->
			@mod.next @program._id, ['aa']
			.should.eventually.have.property '_id'
			.be.deep.equal @dispatch._id

		it "calls postDelivery", ->
			@mod.next @program._id
			.then => @dispatchDelivery.delivered.calledOnce
			.should.eventually.be.ok

		it "resolves to the dispatch", ->
			@mod.next @program._id
			.should.eventually.have.property '_id'
			.to.deep.equal @dispatch._id
		it "calls done of _postDelivery()", ->
			@mod.next @program._id
			.then => @mockPromise.done.called.should.be.ok
		it "resolves to null if startDate is greater than currentDate", ->
			# Mocking current date to be before the startDAte
			@date.now.returns new Date 2014, 0, 1
			@mod.next @program._id
			.should.eventually.equal null
		it "resolves to Dispatch if startDate is less than currentDate", ->
			# Mocking current date to be after the startDate
			@date.now.returns new Date 2014, 2,1
			@mod.next @program._id
			.should.eventually.have.property '_id'
			.to.deep.equal @dispatch._id

	describe "subscriptionCreated()", ->
		beforeEach ->
			sinon.stub @dispatchFac, 'createForSubscriptionId'
			.resolves 'ok'
		it "calls createForSubscriptionId", ->
			@mod.subscriptionCreated 123345
			.then (data) =>
				data.should.equal 'ok'
				@dispatchFac.createForSubscriptionId.calledWith 123345
				.should.be.ok
		it "calls _createDispatchable", ->
			@mod.subscriptionCreated 123345
			.should.eventually.equal 'ok'
	describe "subscriptionUpdated()", ->
		beforeEach ->
			sinon.stub @dispatchFac, 'updateForSubscriptionId'
			.resolves 'ok'
		it "calls updateForSubscriptionId", ->
			@mod.subscriptionUpdated 123345
			.then (data) =>
				data.should.equal 'ok'
				@dispatchFac.updateForSubscriptionId.calledWith 123345
				.should.be.ok
		it "calls _createDispatchable", ->
			@mod.subscriptionUpdated 123345
			.should.eventually.equal 'ok'
	describe "_resourceUpdated()", ->
		beforeEach ->
			sinon.stub @mod, 'campaignUpdated'
			.resolves 100
			@mockDataSetup()
		it "resolves an array", ->
			resource = 'Campaign'
			match = 'program'
			@mod._resourceUpdated resource, match, @program._id
			.should.eventually.eql [100]
