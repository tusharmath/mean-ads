BaseController = require '../backend/controllers/BaseController'
SubscriptionController = require '../backend/controllers/SubscriptionController'
ModelFactory = require '../backend/factories/ModelFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
Dispatcher = require '../backend/modules/Dispatcher'
{mockDataSetup} = require './mocks/MockData'
{Injector} = require 'di'

describe 'SubscriptionController:', ->

	beforeEach ->
		#Initial Setup
		@req = user : {sub: 9000}, params: {id: 9010}
		@res = send: sinon.spy()

		# Injector
		@injector = new Injector [MongooseProviderMock]

		#Mocks
		@mockDataSetup = mockDataSetup

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		#Models
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.Models

		#Dispatcher
		@dispatcher = @injector.get Dispatcher

		#Subscription Controller
		@mod = @injector.get SubscriptionController

	afterEach ->
		@mongo.__reset()
	it "actions should exist", ->
		@mod.actions.should.be.an.instanceOf BaseController

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
