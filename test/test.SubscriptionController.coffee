ControllerFactory = require '../backend/factories/ControllerFactory'
ModelFactory = require '../backend/factories/ModelFactory'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
{mockDataSetup} = require './mocks/MockData'
{Injector} = require 'di'

describe 'SubscriptionController:', ->

	beforeEach ->
		#Initial Setup
		@req = user : sub: 9000
		@res = send: sinon.spy()

		# Injector
		@injector = new Injector [MongooseProviderMock]

		#Mocks
		@mockDataSetup = mockDataSetup


		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		# Controller Factory
		ctrlFac = @injector.get ControllerFactory
		ctrlFac.init()
		.then (ctrls) =>  @mod = ctrls.Subscription

		#Models
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.Models

	afterEach ->
		@mongo.__reset()

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
