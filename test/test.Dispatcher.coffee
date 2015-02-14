MongooseProviderMock = require './mocks/MongooseProviderMock'
{mockDataSetup} = require './mocks/MockData'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
_ = require 'lodash'
{ErrorPool} = require '../backend/config/error-codes'

_json = (obj) ->
	JSON.parse JSON.stringify obj
describe 'Dispatcher:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# Dispatcher
		@mod = @injector.getModule 'modules.Dispatcher', mock: no
		@mod.Models = {}

		#MongooseProvier
		@mongo = @injector.getModule 'providers.MongooseProvider', mock: no

		# DateProvider
		@date = @injector.getModule 'providers.DateProvider'
		@date.now.returns new Date 2014, 1, 2

		#ModelFactory
		@modelFac = @injector.getModule 'factories.ModelFactory', mock: no
		@Models = @modelFac.models()

		#Mock Data
		@mockDataSetup = mockDataSetup

		#DispatchPostDelivery
		@mockPromise = done: sinon.spy()
		@dispatchDelivery = @injector.getModule 'modules.DispatchPostDelivery'
		@dispatchDelivery.delivered.returns @mockPromise

		#DispatchFactory
		@dispatchFac = @injector.getModule 'factories.DispatchFactory', mock: no

	afterEach ->
		@mongo.__reset()

	describe "next()", ->
		beforeEach ->
			# Fake dispatch
			@mockDataSetup()

		it "queries by program id", ->
			@mod.next @program._id
			.then (d) -> d[0]
			.should.eventually.have.property 'markup'
			.equal "hello world 1"

		it "queries null with keywords", ->
			@mod.next @program._id, keywords: ['ff']
			.should.eventually.be.of.length 0
		it "queries with keywords", ->
			@mod.next @program._id, keywords: ['aa']
			.should.eventually.be.of.length 1

		it "calls postDelivery methods thrice", ->
			@mod.next @program._id, limit: 3
			.then => @dispatchDelivery.delivered.calledThrice
			.should.eventually.be.ok

		it "calls postDelivery with args", ->
			@mod.next @program._id, keywords: ['aa', 'bb']
			.then =>
				[dispatch, keyName] = @dispatchDelivery.delivered.getCall(0).args
				keyName.should.equal 'aa'
				dispatch._id.should.deep.	equal @dispatch._id

		it "resolves to the dispatch", ->
			@mod.next @program._id
			.then (d) -> d[0]
			.should.eventually.have.property '_id'
			.to.deep.equal @dispatch._id
		it "calls done of _postDelivery()", ->
			@mod.next @program._id, limit: 3
			.then => @mockPromise.done.calledThrice.should.be.ok
		it "resolves to null if startDate is greater than currentDate", ->
			# Mocking current date to be before the startDAte
			@date.now.returns new Date 2014, 0, 1
			@mod.next @program._id
			.should.eventually.be.of.length 0
		it "resolves to Dispatch if startDate is less than currentDate", ->
			# Mocking current date to be after the startDate
			@date.now.returns new Date 2014, 2, 1
			@mod.next @program._id
			.then (d) -> d[0]
			.should.eventually.have.property '_id'
			.to.deep.equal @dispatch._id
		it "resolves to an array of length equal to limit", ->
			@mod.next @program._id, limit: 2
			.should.eventually.be.of.length 2
	describe "getAllowedOrigins()", ->
		it "returns an array", ->
			@mod.getAllowedOrigins()
			.should.deep.equal []
		it "returns the first allowed origin", ->
			dispatches = [
				{allowedOrigins: ['a']}
				{allowedOrigins: []}
				{allowedOrigins: ['b', 'c']}
			]
			@mod.getAllowedOrigins dispatches
			.should.deep.equal ['a']
		it "ignores empty allowedOrigins", ->
				dispatches = [
					{allowedOrigins: []}
					{allowedOrigins: ['b', 'c']}
					{allowedOrigins: ['a']}
				]
				@mod.getAllowedOrigins dispatches
				.should.deep.equal ['b', 'c']
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
