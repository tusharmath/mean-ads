MongooseProviderMock = require './mocks/MongooseProviderMock'
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
		@mod = @injector.getModule 'factories.DispatchFactory', mock: false
		@mod.Models = {}

		#SubscriptionPopulator
		@subPopulator =  @injector.getModule 'modules.SubscriptionPopulator', mock: false

		#Utils
		# @utils = do require '../backend/Utils'

		#MongooseProvier
		@mongo = @injector.getModule 'providers.MongooseProvider', mock: false

		# DateProvider
		# @date = @injector.getModule 'providers.DateProvider'

		#ModelFactory
		@modelFac = @injector.getModule 'factories.ModelFactory', mock: false
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
		it "calls HTML minifier", ->
			{_id} = @subscriptionP.campaign.program.style
			{style} = @subscriptionP.campaign.program
			style.html = "<div> A A A </div>    <p> B B B </p>"
			style.css = ''
			@mod._interpolateMarkup @subscriptionP
			.should.eventually.equal "<div class=\"ae-#{_id}\"><div>A A A</div><p>B B B</p></div>"
		# TODO: Write independent tests

	describe "_createDispatchable()", ->
		beforeEach ->
			sinon.stub @mod, '_interpolateMarkup'
			.resolves 'hello world'

			@mockDataSetup()
			.then => @subPopulator.populateSubscription @subscription
			.then (@subscriptionP) => #P: Populated

		it "save dispatch", ->
			@subscriptionP.campaign.program.allowedOrigins = ['http://a.com', 'http://b.com']
			@mod._createDispatchable @subscriptionP
			.then (dispatch) =>
				dispatch = _json dispatch
				dispatch.markup.should.equal 'hello world'
				dispatch.subscription.toString().should.eql @subscriptionP._id.toString()
				dispatch.program.toString().should.eql @subscriptionP.campaign.program._id.toString()
				dispatch.keywords.should.deep.equal ['inky', 'pinky', 'ponky']
				dispatch.allowedOrigins.should.deep.equal ['http://a.com', 'http://b.com']
		it "Ignores dispatch if campaign is not enabled", ->
			@subscriptionP.campaign.isEnabled = false
			@mod._createDispatchable @subscriptionP
			.then => @Models.Dispatch.count().execQ()
			.should.eventually.equal 3
		it "Ignores dispatch if used credits equal totalCredits", ->
			@subscriptionP.usedCredits = @subscriptionP.totalCredits = 120
			@mod._createDispatchable @subscriptionP
			.then =>@Models.Dispatch.count().execQ()
			.should.eventually.equal 3
		### TODO: remove Subscriptions don't expire
		it "Ignores dispatch, subscription has expired", ->
			@date.now.returns new Date 2010, 1, 1
			@mod._createDispatchable @subscriptionP
			.then => @Models.Dispatch.count().execQ()
			.should.eventually.equal 3
		###
		it "Creates a Dispatch with subscription start date", ->
			@subscriptionP.startDate = startDate = new Date Date.now()
			@mod._createDispatchable @subscriptionP
			.should.eventually.have.property 'startDate'
			.to.equalDate startDate

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