BaseController = require '../backend/controllers/BaseController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{Injector, Provide} = require 'di'
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

	describe "crud()", ->
		it "throws if resource name is not found", ->
			@mod.resourceName = 'FakeResource'
			expect => @mod.crud()
			.to.throw 'FakeResource was not found'
		it "resuts model", ->
			@mod.crud().should.equal @mod.modelFac.Models.Subscription

	# describe "$create()", ->
	# 	beforeEach ->
	# 		@req = user: 123, body: 'apples'
	# 		@res = {}
	# 		@out = @mod.$create @req, @res
	# 	it 'save the obj', ->
	# 		@out.should.eventually.equal {aa:1}
