Dispatcher = require '../backend/modules/Dispatcher'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{mockDataSetup} = require './mocks/MockData'
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
		@Models = @modelFac.models()

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
		it "creates html WITHOUT css", ->
			{_id} = @subscriptionP.campaign.program.style
			@subscriptionP.campaign.program.style.css = ''
			@mod._interpolateMarkup @subscriptionP
			.should.eventually.equal "<div class=\"ae-#{_id}\"><div>aaa</div><h2 href=\"ccc\">bbb</h2></div>"

		it "creates html WITH css", ->
			{_id} = @subscriptionP.campaign.program.style
			@mod._interpolateMarkup @subscriptionP
			.should.eventually.equal "<style>.ae-#{_id} p{position:absolute}.ae-#{_id} a.selected{color:#f3a}</style><div class=\"ae-#{_id}\"><div>aaa</div><h2 href=\"ccc\">bbb</h2></div>"

		# TODO: Write independent tests

	describe "_createDispatchable()", ->
		beforeEach ->
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'

			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "save dispatch", ->
			@subscriptionP.campaign.keywords = ["apples", "bapples"]
			@mod._createDispatchable @subscriptionP
			.then (dispatch) =>
				dispatch = _json dispatch
				dispatch.markup.should.equal 'hello world'
				dispatch.subscription.toString().should.eql @subscriptionP._id.toString()
				dispatch.program.toString().should.eql @subscriptionP.campaign.program._id.toString()
				dispatch.keywords.should.be.of.length 2

	describe "_removeDispatchable()", ->
		beforeEach ->
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'
			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (@subscriptionP) =>
				@mod._createDispatchable @subscriptionP
			.then (@dispatch) =>

		it "expectation", ->
			@mod._removeDispatchable @subscription._id
			.then =>
				@Models.Dispatch.findByIdQ @dispatch._id
			.then (data) -> expect(data).to.be.null

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
		beforeEach ->
			sinon.spy @mod, '_postDispatch'
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'
			@mockDataSetup()
			.then =>
				@mod._populateSubscription @subscription
			.then (@subscriptionP) =>
				@subscriptionP.campaign.keywords = ['aa', 'bb']
				@mod._createDispatchable @subscriptionP
			.then (@dispatch) =>

		it "queries by program id", ->
			@mod.next @program._id
			.should.eventually.be.equal "hello world"

		it "queries null with keywords", ->
			@mod.next @program._id, ['cc']
			.should.eventually.be.equal ""
		it "queries with keywords", ->
			@mod.next @program._id, ['aa']
			.should.eventually.be.equal "hello world"

		it "calls _postDispatch", ->
			@mod.next @program._id
			.then => @mod._postDispatch.calledWith @dispatch
			.should.be.ok

	describe "subscriptionCreated()", ->

		beforeEach ->
			sinon.stub @mod, '_populateSubscription'
			.resolves 'sub-data'
			sinon.stub @mod, '_createDispatchable'
			.resolves 'disp-data'

		it "calls _populateSubscription", ->
			@mod.subscriptionCreated 123345
			.then =>
				@mod._populateSubscription.calledWith 123345
				.should.be.ok

		it "calls _createDispatchable", ->
			@mod.subscriptionCreated 123345
			.should.eventually.equal 'disp-data'

	describe "_updateDeliveryDate()", ->
		beforeEach ->
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'
			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (subscriptionP) => @mod._createDispatchable subscriptionP
			.then (@dispatch) => @dispatch.update lastDeliveredOn: new Date 10, 10, 10

		it "updates delivery date", ->
			@mod._updateDeliveryDate @dispatch
			.then => @dispatch.lastDeliveredOn.should.be.greaterThan new Date 10, 10, 10

	describe "_postDispatch()", ->
		beforeEach ->
			sinon.stub @mod, '_increaseUsedCredits'
			sinon.stub @mod, '_removeDispatchable'
			sinon.stub @mod, '_updateDeliveryDate'
			@mockDataSetup()
			.then => @mod._populateSubscription @subscription
			.then (subscriptionP) => @mod._createDispatchable subscriptionP
			.then (@dispatch) =>

		#TODO: Tired of writing tests
		it "updates used credits of subscription"
		it "updates last delivery date of dispatch"
		it "removes expired subscriptions"
		it "removes exausted subscriptions"

	describe "_resourceUpdated()", ->
		beforeEach ->
			sinon.stub @mod, 'campaignUpdated'
			.resolves 100
			@mockDataSetup()
		it "resolves an array", ->
			resource = 'Campaign'
			match = 'program'
			@mod._resourceUpdated resource, match, @program._id
			.should.eventually.eql [100]

	describe "subscriptionUpdated()", ->
		beforeEach ->
			sinon.stub @mod, '_removeDispatchable'
			.resolves null
			sinon.stub @mod, 'subscriptionCreated'
			.resolves 'subscription-created'
		it "calls _removeDispatchable", ->
			@mod.subscriptionUpdated 123456
			.then =>
				@mod._removeDispatchable.calledWith 123456
				.should.be.ok
		it "calls subscriptionCreated", ->
			@mod.subscriptionUpdated 123456
			.should.eventually.equal 'subscription-created'



	# describe "styleUpdated()", ->
	# 	beforeEach ->
	# 		@mockDataSetup()
	# 	it "updates dispatches", ->
	# 		@mod.styleUpdated @style._id
	# 		.should.eventually.equal 'yankie'