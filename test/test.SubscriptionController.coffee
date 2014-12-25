BaseController = require '../backend/controllers/BaseController'
SubscriptionController = require '../backend/controllers/SubscriptionController'
ModelFactory = require '../backend/factories/ModelFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
Dispatcher = require '../backend/modules/Dispatcher'
Mailer = require '../backend/modules/Mailer'
MailgunProviderMock = require './mocks/MailgunProviderMock'
DispatchStamper = require '../backend/modules/DispatchStamper'
{mockDataSetup} = require './mocks/MockData'
{Injector} = require 'di'

describe 'SubscriptionController:', ->

	beforeEach ->
		#Initial Setup
		@req = user : {sub: 9000}, params: {id: 9010}, signedCookies: {}
		@res = send: sinon.spy(), set: sinon.spy()

		# Injector
		@injector = new Injector [MongooseProviderMock, MailgunProviderMock]

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

		# Mailer
		@mailer = @injector.get Mailer
		sinon.stub @mailer, 'sendQ'
		.resolves 'mail-sent'

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
		it "should have email route", ->
			[action, route] = @mod.actions.actionMap.$email
			action.should.equal 'post'
			route 'subscriptions'
			.should.equal '/core/subscriptions/:id/email'

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
	describe "convert()", ->
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
			@mod.convert.should.be.a.Function

		it "updates conversion if is in signedCookies._sub", ->
			@mod.convert @req, @res
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'conversions'
			.equals 221

		it "ignores conversion if is NOT in signedCookies._sub", ->
			@stamper.isConvertableSubscription.returns no
			@mod.convert @req, @res
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'conversions'
			.equals 220

	describe "_emailQ()", ->
		beforeEach ->
			@mockDataSetup()
		it "sends mail with from", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.then => @mailer.sendQ.getCall(0).args[0]
			.should.eventually.have.property 'from'
			.equal 'noreply@meanads.com'
		it "sends mail with to", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.then => @mailer.sendQ.getCall(0).args[0]
			.should.eventually.have.property 'to'
			.equal 'vendy@pendy.com'
		it "sends mail with subject", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.then => @mailer.sendQ.getCall(0).args[0]
			.should.eventually.have.property 'subject'
			.equal "Performance report of your subscription #{@subscription._id}"
		it "sends mail with template", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.then => @mailer.sendQ.getCall(0).args[0]
			.should.eventually.have.property 'template'
			.equal "subscription-report"
		it "sends mail with locals", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.then => @mailer.sendQ.getCall(0).args[0]
			.should.eventually.have.property 'locals'
			.deep.equal {@subscription}
		it "resolves with mail-sent", ->
			@mod._emailQ @subscription, 'vendy@pendy.com'
			.should.eventually.equal 'mail-sent'


	describe "$email()", ->
		beforeEach ->
			sinon.spy @mod, '_emailQ'
			@mockDataSetup()
		it "be a function",  -> @mod.actions.$email.should.be.a.Function
		it "calls _emailQ with subscription", ->
			@req.params.id = @subscription._id
			@mod.actions.$email @req
			.then => @mod._emailQ.getCall(0).args[0]._id
			.should.eventually.deep.equal @subscription._id
		it "calls _emailQ with emailTo", ->
			@req.params.id = @subscription._id
			@mod.actions.$email @req
			.then => @mod._emailQ.getCall(0).args[1]
			.should.eventually.deep.equal 'a@a.com'
