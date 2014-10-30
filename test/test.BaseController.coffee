BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'
Q = require 'q'
ErrorCodes = require '../backend/config/error-codes'


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
		mockPromises.install Q.makePromise

	afterEach ->
		mockPromises.uninstall()
		mockPromises.reset()


	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseController

	describe "$one()", ->
		beforeEach ->
			@req.params= id: 1234
			@crudP.__createCrud 'FakeResource', one: 1000

		it "queries on id", ->
			@mod.$one @req, @res
			mockPromises
			.executeForPromise(
				@crudP.__contracts.FakeResource.one
			)
			@crudP.cruds.FakeResource.one.calledWith(1234).should.be.ok


		it "sends doc", ->
			@req.params.id = 1234
			@mod.$one @req, @res
			mockPromises
			.executeForPromise(
				@crudP.__contracts.FakeResource.one
			)
			@res.send.calledWith(1000).should.be.ok

	describe "$create()", ->
		beforeEach ->
			@crudP.__createCrud 'FakeResource', create: 120
		it "sets user.sub", ->
			@req.user = sub: '123aaa321'
			@req.body = {}
			@mod.$create @req, @res
			@req.body.owner.should.equal '123aaa321'

	describe "$update()", ->
		it "calls send WITH FORBIDDEN_DOCUMENT", ->
			@crudP.__createCrud 'FakeResource', one: owner: 1232321
			@req.user = '123321'
			@req.params = id: 123
			@mod.$update @req, @res
			onePromise = @crudP.__contracts.FakeResource.one
			mockPromises.iterateForPromise onePromise
			mockPromises.iterateForPromise onePromise
			@res.send.calledWith(ErrorCodes.FORBIDDEN_DOCUMENT).should.be.ok

	describe "$count()", ->
		it "adds owner to filters", ->
			@crudP.__createCrud 'FakeResource', count: {}
			@req.query = a:1, b:2
			@req.user = sub: 123321
			@mod._filterKeys = ['a']
			@mod.$count @req, @res
			@crudP.cruds.FakeResource.count.calledWith a: 1, owner: 123321
			.should.be.ok

	describe "$remove()", ->
		it "throw NOTFOUND_DOCUMENT", ->
			@req.params = id: 101010
			@crudP.__createCrud 'FakeResource', one: null
			onePromise = @crudP.__contracts.FakeResource.one
			@mod.$remove @req, @res
			mockPromises.iterateForPromise onePromise
			mockPromises.iterateForPromise onePromise
			@res.send.calledWith(ErrorCodes.NOTFOUND_DOCUMENT).should.be.ok

		it "throw FORBIDDEN_DOCUMENT", ->
			@req.params = id: 101010
			@req.user = sub: 1234

			@crudP.__createCrud 'FakeResource', one: owner: 123
			onePromise = @crudP.__contracts.FakeResource.one
			@mod.$remove @req, @res
			mockPromises.iterateForPromise onePromise
			mockPromises.iterateForPromise onePromise
			@res.send.calledWith(ErrorCodes.FORBIDDEN_DOCUMENT).should.be.ok