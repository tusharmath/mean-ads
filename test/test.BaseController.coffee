BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'
Q = require 'q'
ErrorCodes = require '../backend/config/error-codes'
sinonAsPromised = require('sinon-as-promised') Q.Promise

# TODO: MockCrudsProvider isn't nececssary
describe 'BaseController:', ->
	beforeEach ->
		# Mocking Req/Res Objs
		@res = send: sinon.spy(), status: sinon.spy()
		@req = {}

		# Injectors
		@injector = new Injector Mock

		# injecteds to be tested
		@mod = @injector.get BaseController
		@crudP = @injector.get CrudsProvider

		# Setup
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

	describe "_notFoundDocument()", ->

		it "is function", -> @mod._notFoundDocument.should.be.a.Function

		it "throws if not found", ->
			expect =>
				@mod._notFoundDocument null
			.to.throw ErrorCodes.NOTFOUND_DOCUMENT

		it "returns doc", ->
			doc = {}
			@mod._notFoundDocument doc
			.should.equal doc

	describe "_create()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.body = {}
			@crudP.__createCrud 'FakeResource'
			@create = @crudP.cruds.FakeResource.create = sinon.stub()

		it "be a function", -> @mod._create.should.be.a.Function
		it "attaches owner", ->
			@mod._create @req, @res
			@req.body.owner.should.equal 123

		it "updates via crud.create()", ->
			@req.user = sub: 123
			@req.body = {}
			@mod.crud.create = sinon.stub().resolves 'updated-document'
			@mod._create(@req, @res).should.eventually.equal 'updated-document'

		it "calls crud.create()", ->
			@req.user = sub: 123
			@req.body = a:1, b:2
			@mod._create(@req, @res)
			@create.calledWith(@req.body).should.be.ok

		# it "calls send with doc", ->
		# 	@mod._create @req, @res
		# 	.then =>
		# 		@res.send.calledWith 'updated-document'
		# 		.should.be.ok

		# it "calls send with mean-error", ->
		# 	error = type: 'mean', message: 'you gotta be kidding!'
		# 	@crudP.cruds.FakeResource.create = sinon.stub().rejects error
		# 	@mod._create @req, @res
		# 	.then =>
		# 		@res.send.calledWith error
		# 		.should.be.ok

	describe "_update()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.body = a: 1, b: 2, c: 3
			@req.params = id: 101010
			@crudP.__createCrud 'FakeResource'
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
			@update = @crudP.cruds.FakeResource.update = sinon.stub()
		it "be a function", -> @mod._update.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod._update @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 404", ->
			@one.resolves null
			@mod._update(@req, @res)
			.should.be.rejectedWith 'Document not found'
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod._update(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "updates", ->
			@one.resolves owner: 123
			@update.resolves 'updated-doc'
			@mod._update @req, @res
			.should.eventually.equal 'updated-doc'
		it "updates with req.body and id", ->
			@one.resolves owner: 123
			@update.resolves 'updated-doc'
			@mod._update @req, @res
			.then =>
				@update.calledWith(@req.body, @req.params.id).should.be.ok

	describe "_count()", ->
		beforeEach ->
			@crudP.__createCrud 'FakeResource'
			@count = @crudP.cruds.FakeResource.count = sinon.stub()
		it "be a function", -> @mod._count.should.be.a.Function
		it "calls count", ->
			@req.query = a: 1, b: 2, c: 3
			@req.user = sub: 123
			@count.resolves 100
			@mod._filterKeys = ['a', 'b']
			@mod._count @req, @res
			@count.calledWith a: 1, b: 2, owner: 123
			.should.be.ok
		it "resolves", ->
			@count.resolves 123
			@req.user = sub: 123
			@mod._count @req, @res
			.should.eventually.eql {count: 123}


	describe "_list()", ->
		beforeEach ->
			@crudP.__createCrud 'FakeResource'
			@read = @crudP.cruds.FakeResource.read = sinon.stub()
		it "be a function", -> @mod._list.should.be.a.Function
		it "calls read", ->
			@req.query = a: 1, b: 2, c: 3
			@req.user = sub: 123
			_populate = @req.query.populate = p1: 1, p2: 2
			@mod._filterKeys = ['a', 'b']
			@mod._list @req, @res
			@read.calledWith _populate, {a: 1, b: 2, owner: 123}
			.should.be.ok

	describe "_remove()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.params = id: 101010
			@crudP.__createCrud 'FakeResource'
			 #TODO: set it using the string wala syntax
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
			@delete = @crudP.cruds.FakeResource.delete = sinon.stub()
		it "be a function", -> @mod._remove.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod._remove @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 404", ->
			@one.resolves null
			@mod._remove(@req, @res)
			.should.be.rejectedWith 'Document not found'
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod._remove(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "removes", ->
			@one.resolves owner: 123
			@delete.resolves 'removed-doc'
			@mod._remove @req, @res
			.should.eventually.equal 'removed-doc'
		it "removes doc with id", ->
			@one.resolves owner: 123
			@delete.resolves 'updated-doc'
			@mod._remove @req, @res
			.then => @delete.calledWith(@req.params.id).should.be.ok

	describe "_one()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.params = id: 101010
			@crudP.__createCrud 'FakeResource'
			#TODO: set it using the string wala syntax
			@one = @crudP.cruds.FakeResource.one = sinon.stub()
		it "be a function", -> @mod._one.should.be.a.Function
		it "queries on param.id", ->
			@one.resolves 'fake-doc'
			@mod._one @req, @res
			@one.calledWith(@req.params.id).should.be.ok
		it "sends 404", ->
			@one.resolves null
			@mod._one(@req, @res)
			.should.be.rejectedWith 'Document not found'
		it "sends 403", ->
			@one.resolves owner: 1234
			@mod._one(@req, @res)
			.should.be.rejectedWith 'Only the owner of the document has access'
		it "sends doc", ->
			doc =  owner: 123
			@one.resolves doc
			@mod._one @req, @res
			.should.eventually.equal doc
	describe "_endPromise()", ->
		it "be a function", -> @mod._endPromise.should.be.a.Function

		it "resolve via res.send", ->
			promise = Q 1000
			@mod._endPromise @res, promise
			promise.then => @res.send.calledWith(1000).should.be.ok
		it "reject mean errors", ->
			error = new  Error 'Some Error'
			error.type = 'mean'
			promise = Q.fcall ->
				throw error
			@mod._endPromise @res, promise
			.then => @res.send.calledWith(error).should.be.ok
		it "throw non mean errors", ->
			error = new  Error 'Some Error'
			promise = Q.fcall ->
				throw error
			@mod._endPromise @res, promise
			.should.eventually.be.rejectedWith 'Some Error'

