SubscriptionPopulator = require '../backend/modules/SubscriptionPopulator'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
DateProvider = require '../backend/providers/DateProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{mockDataSetup} = require './mocks/MockData'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'

_json = (obj) ->
	JSON.parse JSON.stringify obj
describe 'SubscriptionPopulator:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# SubscriptionPopulator
		@mod = @injector.get SubscriptionPopulator
		@mod.Models = {}

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		# DateProvider
		@date = @injector.get DateProvider

		#ModelFactory
		@Models = @injector.get ModelFactory

		#Mock Data
		@mockDataSetup = mockDataSetup

	afterEach ->
		@mongo.__reset()

	describe "populateSubscription()", ->
		beforeEach ->
			@mockDataSetup()

		it "populates subscription.campaign",  ->
			@mod.populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign._id.should.eql @campaign._id

		it "populates campaign.program",  ->
			@mod.populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign.program._id.should.eql @program._id

		it "populates program.style",  ->
			@mod.populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign.program.style._id.should.eql @style._id
		it "resolves to null if subscription is not found", ->
			@mod.populateSubscription @mongo.mongoose.Types.ObjectId()
			.should.eventually.equal null