BaseController = require '../backend/controllers/BaseController'
SubscriptionController = require '../backend/controllers/SubscriptionController'
ModelFactory = require '../backend/factories/ModelFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
Dispatcher = require '../backend/modules/Dispatcher'
Mailer = require '../backend/modules/Mailer'
MailgunProviderMock = require './mocks/MailgunProviderMock'
DispatchStamper = require '../backend/modules/DispatchStamper'
config = require '../backend/config/config'
{ErrorPool} = require '../backend/config/error-codes'
{mockDataSetup} = require './mocks/MockData'
{Injector} = require 'di'

describe 'SubscriptionController:', ->

	beforeEach ->
		#Initial Setup
		@req =
			user : {sub: 9000}
			params: {id: 9010}
			signedCookies: {}
			query: {uri: 'tusharm.com'}

		@res =
			send: sinon.spy()
			set: sinon.spy()
			status: sinon.spy()

		# Injector
		@injector = new Injector [MongooseProviderMock, MailgunProviderMock]

		#Mocks
		@mockDataSetup = mockDataSetup

		#Models
		@Models = @injector.getModule 'factories.ModelFactory', mock: false

		#Dispatcher
		@dispatcher = @injector.getModule 'modules.Dispatcher'

		#DispatchStamper
		@stamper = @injector.getModule 'modules.DispatchStamper'
		@stamper.isConvertableSubscription.returns yes

		# Mailer
		@mailer = @injector.getModule 'modules.Mailer'
		@mailer.sendQ.resolves 'mail-sent'

		#Subscription Controller
		@mod = @injector.getModule 'controllers.SubscriptionController', mock: false

	afterEach ->
		@Models.mongooseP.__reset()
	it "actions should exist", ->
		@mod.actions.should.be.an.instanceOf BaseController

	describe "actionMap", ->
		it "has convertActionMap", ->
			[method, route] = @mod.actions.actionMap.$convert
			method.should.equal 'get'
			route 'subscription'
			.should.equal '/subscription/:id/convert.gif'
		it "should have email route", ->
			[action, route] = @mod.actions.actionMap.$email
			action.should.equal 'post'
			route 'subscriptions'
			.should.equal '/core/subscriptions/:id/email'

	describe "$credits()", ->
		beforeEach ->
			@mockDataSetup()
		it "be a function", -> @mod.actions.$credits.should.be.a.Function
		it "returns creditDistribution", ->
			@mod.actions.$credits @req
			.should.eventually.have.property 'creditDistribution'
			.equal 7000
		it "returns credtUsage", ->
			@mod.actions.$credits @req
			.should.eventually.have.property 'creditUsage'
			.equal 360
	describe "postCreateHooks()", ->
		beforeEach ->
			@dispatcher.subscriptionCreated.resolves null
		it "calls subscriptionCreated", ->
			@mod.postCreateHook _id: 1000
			.then =>
				@dispatcher.subscriptionCreated.calledWith 1000
				.should.be.ok
	describe "postUpdateHooks()", ->
		beforeEach ->
			@dispatcher.subscriptionUpdated.resolves null
		it "calls subscriptionUpdated", ->
			@mod.postUpdateHook _id: 1000
			.then =>
				@dispatcher.subscriptionUpdated.calledWith 1000
				.should.be.ok
	describe "_convertQ()", ->
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
			@mod._convertQ.should.be.a.Function

		it "updates conversion if is in signedCookies._sub", ->
			@mod._convertQ @req, @res
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'conversions'
			.equals 221

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
		it "be a function", -> @mod.actions.$email.should.be.a.Function
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
	describe "$convert()", ->
		beforeEach ->
			@fakePromise = done: sinon.spy()
			sinon.stub @mod, '_convertQ'
			.returns @fakePromise
		it "be a function", ->
			@mod.actions.$convert.should.be.a.Function
		it "sends transparent image", ->
			@mod.actions.$convert @req, @res
			.should.eventually.deep.equal config.transparentGif.image
		it "sets content-type", ->
			@mod.actions.$convert @req, @res
			.then => @res.set.calledWith 'Content-Type', 'image/gif'
			.should.eventually.be.ok
		it "calls the _convertQ", ->
			@mod.actions.$convert @req, @res
			.then => @mod._convertQ.calledWith @req
			.should.eventually.be.ok
		it "calls the _convertQ.done()", ->
			@mod.actions.$convert @req, @res
			.then => @fakePromise.done.called
			.should.eventually.be.ok

	describe "_clickAckQ()", ->
		beforeEach ->
			@mockDataSetup()
			.then =>
				# Request Mock
				@req.params = id: @subscription._id

				# Mocking the conversion count
				@Models.Subscription.findByIdAndUpdate @subscription._id, clicks: 220
				.execQ()

		it "be a function", ->
			@mod._clickAckQ.should.be.a.Function

		it "updates clicks", ->
			@mod._clickAckQ @subscription._id
			.then => @Models.Subscription.findByIdQ @subscription._id
			.should.eventually.have.property 'clicks'
			.equals 221

	describe "$clickAck()", ->
		beforeEach ->
			@fakePromise = done: sinon.spy()
			sinon.stub @mod, '_clickAckQ'
			.returns @fakePromise
		it "be a function", ->
			@mod.actions.$clickAck.should.be.a.Function
		it "sends null", ->
			@mod.actions.$clickAck @req, @res
			.should.eventually.equal null
		it "sets Location header", ->
			@mod.actions.$clickAck @req, @res
			.then => @res.set.calledWith 'Location', 'tusharm.com'
			.should.eventually.be.ok
		it "sets status to 301", ->
			@mod.actions.$clickAck @req, @res
			.then => @res.status.calledWith 302
			.should.eventually.be.ok

		it "calls the _clickAckQ", ->
			@mod.actions.$clickAck @req, @res
			.then => @mod._clickAckQ.calledWith @req.params.id
			.should.eventually.be.ok
		it "calls the _clickAckQ.done()", ->
			@mod.actions.$clickAck @req, @res
			.then => @fakePromise.done.called
			.should.eventually.be.ok
		it "throws if uri is not present", ->
			delete @req.query.uri
			expect => @mod.actions.$clickAck @req, @res
			.to.throw ErrorPool.INVALID_PARAMETERS