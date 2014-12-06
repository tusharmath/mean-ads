BaseController = require '../backend/controllers/BaseController'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
ModelFactory = require '../backend/factories/ModelFactory'
{annotate, Injector, Provide} = require 'di'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'

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
			.to.throw ErrorPool.FORBIDDEN_DOCUMENT

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
			@req =
				user: {sub: 123}
				body: {name: 'Tushar', age: 10}
				params: id: 123

			#Stubbing getModel
			sinon.stub @mod, 'getModel'
			.returns @mongo.__fakeModel FakeSchema

			#Adding Mock Data Returns a promise
			Q.all [
				@mod.$create user: {sub: 1000}, body: {name: 'TusharA', age: 20}
				@mod.$create user: {sub: 1000}, body: {name: 'TusharB', age: 20}
				@mod.$create user: {sub: 1000}, body: {name: 'TusharC', age: 30}
				@mod.$create user: {sub: 1000}, body: {name: 'TusharD', age: 30}
				@mod.$create user: {sub: 1001}, body: {name: 'TusharE', age: 20}
			]

		describe "$create()", ->
			beforeEach ->
				@out = @mod.$create @req, @res

			it 'has owner', ->
				@out.should.eventually.have.property 'owner'

			it 'has _id', ->
				@out.should.eventually.have.property '_id'
			it "calls the post create hook", ->
				@req.user.sub = 1234
				@req.body = {}
				sinon.stub @mod, 'postCreateHook'
				.resolves 'post-created-responses'
				@mod.$create @req
				.should.eventually.equal 'post-created-responses'

		describe "$update()", ->
			beforeEach ->
				req =
					user: {sub: 1234}
					body: {name: 'Tushar', age: 10}
				@mod.$create req
				.then (obj) => @req.params.id = obj._id


			it 'throws FORBIDDEN_DOCUMENT', ->
				@mod.$update @req
				.should.be.rejectedWith ErrorPool.FORBIDDEN_DOCUMENT
			it "updates doc", ->
				@req.user.sub = 1234
				@req.body.name = 'Mathur'
				@mod.$update @req
				.should.eventually.have.property 'name'
				.equal 'Mathur'

			it "deletes the _id before updating", ->
				@req.user.sub = 1234
				@req.body._id = 122
				spy = sinon.spy @mod.getModel(), 'findByIdAndUpdate'
				@mod.$update @req
				.should.eventually.have.property '_id'

			it "calls the post updated hook", ->
				@req.user.sub = 1234
				@req.body._id = 122
				sinon.stub @mod, 'postUpdateHook'
				.resolves 'post-updated-responses'
				spy = sinon.spy @mod.getModel(), 'findByIdAndUpdate'
				@mod.$update @req
				.should.eventually.equal 'post-updated-responses'

		describe "$count()", ->
			beforeEach ->
				@mod._filterKeys = ['age']

			it "gets count", ->
				@req.user.sub = 1000
				@mod.$count @req
				.should.eventually.eql count: 4

			it "counts with query params", ->
				@req.user.sub = 1000
				@req.query = age: 20
				@mod.$count @req
				.should.eventually.eql count: 2

		describe "$list()", ->
			beforeEach ->
				@mod._filterKeys = ['age']

			it "gets list", ->
				@req.user.sub = 1000
				@mod.$list @req
				.should.eventually.be.of.length 4

			it "counts with query params", ->
				@req.user.sub = 1000
				@req.query = age: 20
				@mod.$list @req
				.should.eventually.be.of.length 2

		describe "$remove()", ->
			beforeEach ->
				@mod.$create user: {sub: 1000}, body: {name: 'TusharC', age: 30}
				.then (doc) => @req.params.id = doc._id

			it "throws FORBIDDEN_DOCUMENT", ->
				@req.user.sub = 1001
				@mod.$remove @req
				.should.be.rejectedWith ErrorPool.FORBIDDEN_DOCUMENT

			it "removes the element", ->
				@req.user.sub = 1000
				@mod.$remove @req
				.then => @mod.getModel().find().execQ()
				.should.eventually.have.length.of 5

		describe "$one()", ->
			beforeEach ->
				@mod.$create user: {sub: 1000}, body: {name: 'TusharC', age: 30}
				.then (doc) => @req.params.id = doc._id

			it "throws FORBIDDEN_DOCUMENT", ->
				@req.user.sub = 1001
				@mod.$one @req
				.should.be.rejectedWith ErrorPool.FORBIDDEN_DOCUMENT

			it "returns element", ->
				@req.user.sub = 1000
				@mod.$one @req
				.should.eventually.have.property '_id'
				.eql @req.params.id
