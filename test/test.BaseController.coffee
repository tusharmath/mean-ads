ioc = require './ioc'
Q = require 'q'
{ErrorPool} = require '../backend/config/error-codes'

describe 'BaseController:', ->

	beforeEach ->
		# BaseCtrl
		{@mod, @afterEach, @mongo} = ioc.resolve 'controllers.BaseController'
		@mod.resourceName = 'Subscription'

	afterEach ->
		@afterEach()


	describe "getModel()", ->
		it "throws if resource name is not found", ->
			@mod.resourceName = 'FakeResource'
			expect => @mod.getModel()
			.to.throw 'FakeResource was not found'

		it "returns model", ->
			@mod.getModel().should.equal @mod.models.Subscription

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

			it "throws when document is not found", ->
				@req.user.sub = 1001
				@req.params.id = @mongo.mongoose.Types.ObjectId()
				@mod.$update @req
				.should.be.rejectedWith ErrorPool.NOTFOUND_DOCUMENT

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
			it "ignores user.sub if its open for all", ->
				@req.user.sub = 10000
				@req.query = age: 30
				@mod.hasListOwner = no
				@mod.$list @req
				.should.eventually.be.of.length 2
		describe "$remove()", ->
			beforeEach ->
				@mod.$create user: {sub: 1000}, body: {name: 'TusharC', age: 30}
				.then (doc) => @req.params.id = doc._id.toString()

			it "throws FORBIDDEN_DOCUMENT", ->
				@req.user.sub = 1001
				@mod.$remove @req
				.should.be.rejectedWith ErrorPool.FORBIDDEN_DOCUMENT

			it "throws when document is not found", ->
				@req.user.sub = 1001
				@req.params.id = @mongo.mongoose.Types.ObjectId()
				@mod.$remove @req
				.should.be.rejectedWith ErrorPool.NOTFOUND_DOCUMENT

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

			it "throws when document is not found", ->
				@req.user.sub = 1001
				@req.params.id = @mongo.mongoose.Types.ObjectId()
				@mod.$one @req
				.should.be.rejectedWith ErrorPool.NOTFOUND_DOCUMENT
