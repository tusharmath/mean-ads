ControllerFactory = require '../backend/factories/ControllerFactory'
BaseController = require '../backend/controllers/BaseController'
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

		# Controller Factory - Q
		ctrlFac = @injector.get ControllerFactory
		ctrlFac.init()
		.then (ctrls) =>  @mod = ctrls.Subscription
	afterEach ->
		@mongo.__reset()
	it "actions should exist", ->
		@mod.actions.should.be.an.instanceOf BaseController

	describe "$credits()", ->
		beforeEach ->
			@mockDataSetup()
		it "be a function", -> @mod.$credits.should.be.a.Function
		it "returns creditDistribution",  ->
			@mod.$credits @req
			.should.eventually.have.property 'creditDistribution'
			.equal 7000
		it "returns credtUsage",  ->
			@mod.$credits @req
			.should.eventually.have.property 'creditUsage'
			.equal 360
	describe "$create()", ->
		beforeEach ->
			@mockDataSetup()
		it "calls base $create", ->
			sinon.stub @mod._base, '$create'
			.resolves _id: 'subscription-created'

			sinon.stub @dispatcher, 'subscriptionCreated'
			.resolves _id: 'subscription-created'

			@mod.$create @req
			.should.eventually.deep.equal _id: 'subscription-created'
	describe "$update()", ->
		beforeEach ->
			@mockDataSetup()
		it "calls base $update", ->
			sinon.stub @mod._base, '$update'
			.resolves _id: 'subscription-updated'

			sinon.stub @dispatcher, 'subscriptionUpdated'
			.resolves _id: 'subscription-updated'
			@mod.$update @req
			.should.eventually.deep.equal _id: 'subscription-updated'