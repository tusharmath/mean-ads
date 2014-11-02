BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'
Q = require 'q'
ErrorCodes = require '../backend/config/error-codes'
sinonAsPromised = require('sinon-as-promised') Q.Promise

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

	describe "_sendDocument()", ->

		it "is function", -> @mod._sendDocument.should.be.a.Function

		it "sends doc", ->
			doc = {}
			@mod._sendDocument @res, doc
			@res.send.calledWith doc

	describe "_create()", ->
		beforeEach ->
			@req.user = sub: 123
			@req.body = {}
			@crudP.__createCrud 'FakeResource'
			@crudP.cruds.FakeResource.create = sinon.stub().resolves 'updated-document'

		it "be a function", -> @mod._create.should.be.a.Function
		it "attaches owner", ->
			@mod._create @req, @res
			@req.body.owner.should.equal 123

		it "updates via crud.create()", ->
			@req.user = sub: 123
			@req.body = {}
			@mod.crud.create = sinon.stub().resolves 'updated-document'
			@mod._create(@req, @res).should.eventually.equal 'updated-document'

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
			@req.body = a:1, b:2, c:3
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
			@req.query = a:1, b:2, c:3
			@req.user = sub: 123
			@mod._filterKeys = ['a', 'b']
			@mod._count @req, @res
			@count.calledWith a:1, b:2, owner: 123
			.should.be.ok

	describe "_list()", ->
		beforeEach ->
			@crudP.__createCrud 'FakeResource'
			@read = @crudP.cruds.FakeResource.read = sinon.stub()
		it "be a function", -> @mod._list.should.be.a.Function
		it "calls read", ->
			@req.query = a:1, b:2, c:3
			@req.user = sub: 123
			@mod._filterKeys = ['a', 'b']
			@mod._populate = p1:1, p2:2
			@mod._list @req, @res
			@read.calledWith @mod._populate, {a:1, b:2, owner: 123}
			.should.be.ok


	# describe "$one()", ->
	# 	beforeEach ->
	# 		@req.params = id: 1234
	# 		@crudP.__createCrud 'FakeResource', one: 1000

	# 	it "queries on id", ->
	# 		@mod.$one @req, @res
	# 		@crudP.cruds.FakeResource.one.calledWith(1234).should.be.ok



	# 	it "sends doc", ->
	# 		@req.params.id = 1234
	# 		@mod.$one @req, @res
	# 		mockPromises
	# 		.executeForPromise(
	# 			@crudP.__contracts.FakeResource.one
	# 		)
	# 		@res.send.calledWith(1000).should.be.ok

	# describe "$create()", ->
	# 	beforeEach ->
	# 		@crudP.__createCrud 'FakeResource', create: 120
	# 	it "sets user.sub", ->
	# 		@req.user = sub: '123aaa321'
	# 		@req.body = {}
	# 		@mod.$create @req, @res
	# 		@req.body.owner.should.equal '123aaa321'

	# describe "$update()", ->
	# 	it "calls send WITH FORBIDDEN_DOCUMENT", ->
	# 		@crudP.__createCrud 'FakeResource', one: owner: 1232321
	# 		@req.user = '123321'
	# 		@req.params = id: 123
	# 		@mod.$update @req, @res
	# 		onePromise = @crudP.__contracts.FakeResource.one
	# 		mockPromises.iterateForPromise onePromise
	# 		mockPromises.iterateForPromise onePromise
	# 		@res.send.calledWith(ErrorCodes.FORBIDDEN_DOCUMENT).should.be.ok

	# describe "$count()", ->
	# 	it "adds owner to filters", ->
	# 		@crudP.__createCrud 'FakeResource', count: {}
	# 		@req.query = a:1, b:2
	# 		@req.user = sub: 123321
	# 		@mod._filterKeys = ['a']
	# 		@mod.$count @req, @res
	# 		@crudP.cruds.FakeResource.count.calledWith a: 1, owner: 123321
	# 		.should.be.ok

	# describe "$remove()", ->
	# 	it "throw NOTFOUND_DOCUMENT", ->
	# 		@req.params = id: 101010
	# 		@crudP.__createCrud 'FakeResource', one: null
	# 		onePromise = @crudP.__contracts.FakeResource.one
	# 		@mod.$remove @req, @res
	# 		mockPromises.iterateForPromise onePromise
	# 		mockPromises.iterateForPromise onePromise
	# 		@res.send.calledWith(ErrorCodes.NOTFOUND_DOCUMENT).should.be.ok

	# 	it "throw FORBIDDEN_DOCUMENT", ->
	# 		@req.params = id: 101010
	# 		@req.user = sub: 1234

	# 		@crudP.__createCrud 'FakeResource', one: owner: 123
	# 		onePromise = @crudP.__contracts.FakeResource.one
	# 		@mod.$remove @req, @res
	# 		mockPromises.iterateForPromise onePromise
	# 		mockPromises.iterateForPromise onePromise
	# 		@res.send.calledWith(ErrorCodes.FORBIDDEN_DOCUMENT).should.be.ok