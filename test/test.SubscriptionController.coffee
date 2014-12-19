BaseController = require '../backend/controllers/BaseController'
SubscriptionController = require '../backend/controllers/SubscriptionController'
ModelFactory = require '../backend/factories/ModelFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
Dispatcher = require '../backend/modules/Dispatcher'
DispatchStamper = require '../backend/modules/DispatchStamper'
{mockDataSetup} = require './mocks/MockData'
{Injector} = require 'di'

describe 'SubscriptionController:', ->

	beforeEach ->
		#Initial Setup
		@req = user : {sub: 9000}, params: {id: 9010}, signedCookies: {}
		@res = send: sinon.spy(), set: sinon.spy()

		# Injector
		@injector = new Injector [MongooseProviderMock]

		#Mocks
		@mockDataSetup = mockDataSetup

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		#Models
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.models()

		#Dispatcher
		@dispatcher = @injector.get Dispatcher

		#DispatchStamper
		@stamper = @injector.get DispatchStamper
		sinon.stub @stamper, 'isConvertableSubscription'
		.returns yes


		#Subscription Controller
		@mod = @injector.get SubscriptionController

	afterEach ->
		@mongo.__reset()
	it "actions should exist", ->
		@mod.actions.should.be.an.instanceOf BaseController

	describe "actionMap", ->
		it "has convertActionMap", ->
			[method, route] = @mod.actions.actionMap.$convert
			method.should.equal 'get'
			route 'subscription'
			.should.equal '/subscription/:id/convert'

	describe "$credits()", ->
		beforeEach ->
			@mockDataSetup()
		it "be a function", -> @mod.actions.$credits.should.be.a.Function
		it "returns creditDistribution",  ->
			@mod.actions.$credits @req
			.should.eventually.have.property 'creditDistribution'
			.equal 7000
		it "returns credtUsage",  ->
			@mod.actions.$credits @req
			.should.eventually.have.property 'creditUsage'
			.equal 360
	describe "postCreateHooks()", ->
		beforeEach ->
			sinon.stub @dispatcher, 'subscriptionCreated'
			.resolves null
		it "calls subscriptionCreated", ->
			@mod.postCreateHook _id: 1000
			.then =>
				@dispatcher.subscriptionCreated.calledWith 1000
				.should.be.ok
	describe "postUpdateHooks()", ->
		beforeEach ->
			sinon.stub @dispatcher, 'subscriptionUpdated'
			.resolves null
		it "calls subscriptionUpdated", ->
			@mod.postUpdateHook _id: 1000
			.then =>
				@dispatcher.subscriptionUpdated.calledWith 1000
				.should.be.ok
	describe "$convert()", ->
		beforeEach ->
			@mockDataSetup()
			.then =>
				# Request Mock
				@req.params = id: @subscription._id
				@req.headers = origin: 'http://www.site.com'

				# Mocking the conversion count
				@Models.Subscription.findByIdAndUpdate @subscription._id, conversions: 220
				.execQ()

		it "be a function", ->
			@mod.actions.$convert.should.be.a.Function
		it "sets Access-Control-Allow-Origin Header", ->
			@mod.actions.$convert @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Origin', '*'
			.should.eventually.be.ok


		it "updates conversion if is in signedCookies._sub", ->
			@mod.actions.$convert @req, @res
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'conversions'
			.equals 221

		it "ignores conversion if is NOT in signedCookies._sub", ->
			@stamper.isConvertableSubscription.returns no
			@mod.actions.$convert @req, @res
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'conversions'
			.equals 220