DispatchFactory = require '../backend/factories/DispatchFactory'
Utils = require '../backend/Utils'
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
describe 'DispatchFactory:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# DispatchFactory
		@mod = @injector.get DispatchFactory
		@mod.Models = {}

		#SubscriptionPopulator
		@subPopulator =  @injector.get SubscriptionPopulator

		#Utils
		@utils = @injector.get Utils

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

		# DateProvider
		@date = @injector.get DateProvider

		#ModelFactory
		@modelFac = @injector.get ModelFactory
		@Models = @modelFac.models()

		#Mock Data
		@mockDataSetup = mockDataSetup

	afterEach ->
		@mongo.__reset()

	describe "_interpolateMarkup()", ->

		beforeEach ->
			@mockDataSetup()
			.then =>
				@subPopulator.populateSubscription @subscription
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
			.then => @subPopulator.populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "save dispatch", ->
			@subscriptionP.campaign.keywords = ["apples", "bapples"]
			@subscriptionP.campaign.program.allowedOrigins = ['http://a.com', 'http://b.com']
			@mod._createDispatchable @subscriptionP
			.then (dispatch) =>
				dispatch = _json dispatch
				dispatch.markup.should.equal 'hello world'
				dispatch.subscription.toString().should.eql @subscriptionP._id.toString()
				dispatch.program.toString().should.eql @subscriptionP.campaign.program._id.toString()
				dispatch.keywords.should.be.of.length 2
				dispatch.allowedOrigins.should.deep.equal ['http://a.com', 'http://b.com']
		it "Ignores dispatch if campaign is not enabled", ->
			@subscriptionP.campaign.isEnabled = false
			@mod._createDispatchable @subscriptionP
			.then =>
				@Models.Dispatch.findQ().should.eventually.be.of.length 0
		it "Ignores dispatch if used credits equal totalCredits", ->
			@subscriptionP.usedCredits = @subscriptionP.totalCredits = 120
			@mod._createDispatchable @subscriptionP
			.then =>
				@Models.Dispatch.findQ().should.eventually.be.of.length 0
		it "Ignores dispatch, subscription has expired", ->
			sinon.stub @utils, 'hasSubscriptionExpired'
			.returns yes
			@mod._createDispatchable @subscriptionP
			.then =>
				@Models.Dispatch.findQ().should.eventually.be.of.length 0
		it "Creates a Dispatch with subscription start date", ->
			sinon.stub @utils, 'hasSubscriptionExpired'
			.returns no
			@mod._createDispatchable @subscriptionP
			.then => @Models.Dispatch.findOneQ()
			.should.eventually.have.property 'startDate'
			.to.equalDate @subscriptionP.startDate

	describe "removeForSubscriptionId()", ->
		beforeEach ->
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'
			@mockDataSetup()
			.then => @subPopulator.populateSubscription @subscription
			.then (@subscriptionP) =>
				@mod._createDispatchable @subscriptionP
			.then (@dispatch) =>

		it "expectation", ->
			@mod.removeForSubscriptionId @subscription._id
			.then =>
				@Models.Dispatch.findByIdQ @dispatch._id
			.then (data) -> expect(data).to.be.null

	describe "createForSubscriptionId()", ->

		beforeEach ->
			sinon.stub @subPopulator, 'populateSubscription'
			.resolves 'sub-data'
			sinon.stub @mod, '_createDispatchable'
			.resolves 'disp-data'

		it "calls _populateSubscription", ->
			@mod.createForSubscriptionId 123345
			.then =>
				@subPopulator.populateSubscription.calledWith 123345
				.should.be.ok

		it "calls _createDispatchable", ->
			@mod.createForSubscriptionId 123345
			.should.eventually.equal 'disp-data'


	describe "updateForSubscriptionId()", ->
		beforeEach ->
			sinon.stub @mod, 'removeForSubscriptionId'
			.resolves null
			sinon.stub @mod, 'createForSubscriptionId'
			.resolves 'subscription-created'
		it "calls removeForSubscriptionId", ->
			@mod.updateForSubscriptionId 123456
			.then =>
				@mod.removeForSubscriptionId.calledWith 123456
				.should.be.ok
		it "calls createForSubscriptionId", ->
			@mod.updateForSubscriptionId 123456
			.should.eventually.equal 'subscription-created'