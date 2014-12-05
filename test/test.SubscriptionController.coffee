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
		it "calls actions $create", ->
			sinon.stub @mod.actions, '$create'
			.resolves _id: 'subscription-created'

			sinon.stub @dispatcher, 'subscriptionCreated'
			.resolves _id: 'subscription-created'

			@mod.$create @req
			.should.eventually.deep.equal _id: 'subscription-created'
	describe "$update()", ->
		beforeEach ->
			@mockDataSetup()
		it "calls base $update", ->
			sinon.stub @mod.actions, '$update'
			.resolves _id: 'subscription-updated'

			sinon.stub @dispatcher, 'subscriptionUpdated'
			.resolves _id: 'subscription-updated'
			@mod.$update @req
			.should.eventually.deep.equal _id: 'subscription-updated'