BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'
Q = require 'q'


describe 'BaseController:', ->
	beforeEach ->
		# Mocking Req/Res Objs
		@res = send: sinon.spy()
		@req = params: {}, user: {}, body: {}

	beforeEach ->

		# Injectors
		@injector = new Injector Mock

		# injecteds to be tested
		@mod = @injector.get BaseController
		@crudP = @injector.get CrudsProvider

	beforeEach ->
		# Setup
		@mod.resourceName = 'FakeResource'
		mockPromises.install Q.makePromise

	afterEach ->
		mockPromises.uninstall()
		mockPromises.reset()


	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseController

	describe "one()", ->
		beforeEach ->
			@req.params.id = 1234
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
			@crudP.__createCrud 'FakeResource', one: 1000
			@mod.$one @req, @res
			mockPromises
			.executeForPromise(
				@crudP.__contracts.FakeResource.one
			)
			@res.send.calledWith(1000).should.be.ok

