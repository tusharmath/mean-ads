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
	mockDataSetup = ->
		ownerId = 9000
		campaign =
			name: 'apple-campaign'
			days: 10
			owner: ownerId
		subscription =
			client: 'apples'
			totalCredits: 1000
			data: a:'aaa', b: 'bbb', c: 'ccc'
			owner: ownerId
		program =
			name: 'apple-program'
			owner: ownerId
		style =
			name: 'apple-style'
			html: '<div>{{=it.a}}</div><h2 href="{{=it.c}}">{{=it.b}}</h2>'
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

		#Mock Data
		@mockDataSetup = mockDataSetup


	afterEach ->
		@mongo.__reset()


	describe "_populateSubscription()", ->
		beforeEach ->
			@mockDataSetup()

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

	describe "_interpolateMarkup()", ->
		beforeEach ->
			@mockDataSetup()
			.then =>
				@mod._populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated
		it "creates html without css", ->
			@mod._interpolateMarkup @subscriptionP
			.should.equal "<div>aaa</div><h2 href=\"ccc\">bbb</h2>"

		it "creates html with css", ->
			@subscriptionP.campaign.program.style.css = "p div{position: absolute;}    a.img   {color: #aaa;}"
			@mod._interpolateMarkup @subscriptionP
			.should.equal "<style>p div{position:absolute}a.img{color:#aaa}</style><div>aaa</div><h2 href=\"ccc\">bbb</h2>"

	describe "_createDispatchable()", ->
		beforeEach ->
			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated
		it "save dispatch", ->
			@subscriptionP.campaign.keywords = ["apples", "bapples"]
			@mod._createDispatchable @subscriptionP
			.then (dispatch) =>
				dispatch = _json dispatch
				dispatch.markup.should.exist
				dispatch.subscription.toString().should.eql @subscriptionP._id.toString()
				dispatch.program.toString().should.eql @subscriptionP.campaign.program._id.toString()
				dispatch.keywords.should.be.of.length 2

	describe "_removeDispatchable()", ->
		beforeEach ->
			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "expectation", ->
			@mod._removeDispatchable @subscriptionP._id
			.then =>
				@Models.Dispatch.findOne subscription: @subscriptionP._id
				.execQ()
			.then (data) ->
				expect(data).to.be.null

	describe "_increaseUsedCredits()", ->
		beforeEach ->
			@mockDataSetup()
			.then =>
				@Models.Subscription
				.findByIdAndUpdate @subscription._id, usedCredits: 100
				.execQ()
			.then =>
				@mod._populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "updates used credits", ->
			@mod._increaseUsedCredits @subscriptionP
			.should.eventually.have.property 'usedCredits'
			.equal 101

	describe "next()", ->
	describe "createSubscription()", ->


