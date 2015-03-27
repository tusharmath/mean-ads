MongooseProviderMock = require './mocks/MongooseProviderMock'
{mockDataSetup} = require './mocks/MockData'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'

describe 'SubscriptionSchema:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# Dispatcher
		@mod = @injector.getModule 'modules.Dispatcher', mock: no
		@mod.Models = {}

		#MongooseProvier
		@mongo = @injector.getModule 'providers.MongooseProvider', mock: no

		#ModelFactory
		@Models = @injector.getModule 'factories.ModelFactory', mock: no

		#Mock Data
		@mockDataSetup = mockDataSetup

	afterEach ->
		@mongo.__reset()

	describe "hasCredits()", ->
		beforeEach ->
			# Fake dispatch
			@mockDataSetup()

		it "it exists", ->
			@subscription.hasCredits.should.exist
		it "returns true",  ->
			@subscription.usedCredits = 10
			@subscription.totalCredits = 100
			@subscription.hasCredits.should.be.true

		it "returns false",  ->
			@subscription.usedCredits = 100
			@subscription.totalCredits = 100
			@subscription.hasCredits.should.be.false
