BaseController = require '../backend/controllers/BaseController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
ErrorCodes = require '../backend/config/error-codes'

describe 'BaseController:', ->

	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# BaseCtrl
		@mod = @injector.get BaseController
		@mod.resourceName = 'Subscription'

		#MongooseProvier
		@mongo = @injector.get MongooseProvider

	afterEach ->
		@mongo.__reset()


	describe "_forbiddenDocument()", ->

		it "is function", -> @mod._forbiddenDocument.should.be.a.Function

		it "throws if not an owner", ->
			expect => @mod._forbiddenDocument 1, owner: 2
			.to.throw ErrorCodes.FORBIDDEN_DOCUMENT

		it "returns doc", ->
			doc = owner: 2
			@mod._forbiddenDocument(2, doc).should.equal doc

	describe "getModel()", ->
		it "throws if resource name is not found", ->
			@mod.resourceName = 'FakeResource'
			expect => @mod.getModel()
			.to.throw 'FakeResource was not found'

		it "resuts model", ->
			@mod.getModel().should.equal @mod.modelFac.Models.Subscription

	describe "$controllers:", ->
		beforeEach ->
			FakeSchema =  name: String, age: Number, owner: Number

			#Request
			@req = user: {sub: 123}, body: {name: 'Tushar', age: 10}

			#Stubbing getModel
			sinon.stub @mod, 'getModel'
			.returns @mongo.__fakeModel FakeSchema

		describe "$create()", ->

			beforeEach ->
				@out = @mod.$create @req, @res

			it 'has owner', ->
				@out.should.eventually.have.property 'owner'
