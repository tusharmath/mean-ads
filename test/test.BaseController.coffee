BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'
ErrorCodes = require '../backend/config/error-codes'

describe 'BaseController:', ->
	beforeEach ->
		# Mocking Req/Res Objs
		@res = send: sinon.spy(), status: sinon.spy()
		@req = {}

		# Injectors
		@injector = new Injector Mock

		# injecteds to be tested
		@crudP = @injector.get CrudsProvider
		@crudP.cruds = FakeResource: {}

		@mod = @injector.get BaseController
		@mod.resourceName = 'FakeResource'




	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseController

	describe "_forbiddenDocument()", ->
		it "is function", -> @mod._forbiddenDocument.should.be.a.Function
		it "throws if not an owner", ->
			expect =>
				@mod._forbiddenDocument 1, owner: 2
			.to.throw ErrorCodes.FORBIDDEN_DOCUMENT

		it "returns doc", ->
			doc = owner: 2
			@mod._forbiddenDocument 2, doc
			.should.equal doc

	describe "$create()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.body = {}

			@create = @crudP.cruds.FakeResource.create = sinon.stub()

		it "be a function", -> @mod.$create.should.be.a.Function
		it "attaches owner", ->
			@mod.$create @req, @res
			@req.body.owner.should.equal 123

		it "updates via crud.create()", ->
			@req.user = sub: 123
			@req.body = {}
			@mod.crud.create = sinon.stub().resolves 'updated-document'
			@mod.$create(@req, @res).should.eventually.equal 'updated-document'

		it "calls crud.create()", ->
			@req.user = sub: 123
			@req.body = a:1, b:2
			@mod.$create(@req, @res)
			@create.calledWith(@req.body).should.be.ok

		# it "calls send with doc", ->
		# 	@mod.$create @req, @res
		# 	.then =>
		# 		@res.send.calledWith 'updated-document'
		# 		.should.be.ok

		# it "calls send with mean-error", ->
		# 	error = type: 'mean', message: 'you gotta be kidding!'
		# 	@crudP.cruds.FakeResource.create = sinon.stub().rejects error
		# 	@mod.$create @req, @res
		# 	.then =>
		# 		@res.send.calledWith error
		# 		.should.be.ok

	describe "$update()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.body = a: 1, b: 2, c: 3
			@req.params = id: 101010
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
			@update = @crudP.cruds.FakeResource.update = sinon.stub()
		it "be a function", -> @mod.$update.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod.$update @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod.$update(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "updates", ->
			@one.resolves owner: 123
			@update.resolves 'updated-doc'
			@mod.$update @req, @res
			.should.eventually.equal 'updated-doc'
		it "updates with req.body and id", ->
			@one.resolves owner: 123
			@update.resolves 'updated-doc'
			@mod.$update @req, @res
			.then =>
				@update.calledWith(@req.body, @req.params.id).should.be.ok

	describe "$count()", ->
		beforeEach ->
			@count = @crudP.cruds.FakeResource.count = sinon.stub()
		it "be a function", -> @mod.$count.should.be.a.Function
		it "calls count", ->
			@req.query = a: 1, b: 2, c: 3
			@req.user = sub: 123
			@count.resolves 100
			@mod._filterKeys = ['a', 'b']
			@mod.$count @req, @res
			@count.calledWith a: 1, b: 2, owner: 123
			.should.be.ok
		it "resolves", ->
			@count.resolves 123
			@req.user = sub: 123
			@mod.$count @req, @res
			.should.eventually.eql {count: 123}


	describe "$list()", ->
		beforeEach ->
			@read = @crudP.cruds.FakeResource.read = sinon.stub()
		it "be a function", -> @mod.$list.should.be.a.Function
		it "calls read", ->
			@req.query = a: 1, b: 2, c: 3
			@req.user = sub: 123
			_populate = @req.query.populate = p1: 1, p2: 2
			@mod._filterKeys = ['a', 'b']
			@mod.$list @req, @res
			@read.calledWith _populate, {a: 1, b: 2, owner: 123}
			.should.be.ok

	describe "$remove()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.params = id: 101010
			 #TODO: set it using the string wala syntax
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
			@delete = @crudP.cruds.FakeResource.delete = sinon.stub()
		it "be a function", -> @mod.$remove.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod.$remove @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod.$remove(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "removes", ->
			@one.resolves owner: 123
			@delete.resolves 'removed-doc'
			@mod.$remove @req, @res
			.should.eventually.equal 'removed-doc'
		it "removes doc with id", ->
			@one.resolves owner: 123
			@delete.resolves 'updated-doc'
			@mod.$remove @req, @res
			.then => @delete.calledWith(@req.params.id).should.be.ok

	describe "$one()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.params = id: 101010
			#TODO: set it using the string wala syntax
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
		it "be a function", -> @mod.$one.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod.$one @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod.$one(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "sends doc", ->
			doc =  owner: 123
			@one.resolves doc
			@mod.$one @req, @res
			.should.eventually.equal doc
