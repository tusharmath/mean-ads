Dispatcher = require '../backend/modules/Dispatcher'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'

_json = (obj) ->
	JSON.parse JSON.stringify obj
describe 'Dispatcher:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# Dispatcher
		@mod = @injector.get Dispatcher
		@mod.Models = {}

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		#ModelFactory
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.Models


	afterEach ->
		@mongo.__reset()


	describe "_populateSubscription()", ->
		beforeEach ->
			ownerId = 9000
			campaign =
				name: 'apple-campaign'
				days: 10
				owner: ownerId
			subscription =
				client: 'apples'
				totalCredits: 1000
				data: a:1, b:2, c:3
				owner: ownerId
			program =
				name: 'apple-program'
				owner: ownerId
			style =
				name: 'apple-style'
				html: '<div>{{a}}</div><h2 href="{{c}}">{{b}}</h2>'
				placeholders: ['a', 'b', 'c']
				owner: ownerId

			new @Models.Style style
			.saveQ()
			.then (@style) =>
				program.style = @style._id
				new @Models.Program program
				.saveQ()
			.then (@program) =>
				campaign.program = @program._id
				new @Models.Campaign campaign
				.saveQ()
			.then (@campaign) =>
				subscription.campaign = @campaign._id
				new @Models.Subscription subscription
				.saveQ()
			.then (@subscription) =>

		it "populates subscription.campaign",  ->
			@mod._populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign._id.should.eql @campaign._id

		it "populates campaign.program",  ->
			@mod._populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign.program._id.should.eql @program._id

		it "populates program.style",  ->
			@mod._populateSubscription @subscription._id
			.then (sub) =>
				sub.campaign.program.style._id.should.eql @style._id

	describe "next()", ->
	describe "createSubscription()", ->


