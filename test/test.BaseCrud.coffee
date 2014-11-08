BaseCrud = require '../backend/cruds/BaseCrud'
ModelsProvider = require '../backend/providers/ModelsProvider'
Mock = require './mocks'
Q = require 'q'
{Provide, Injector} = require 'di'

describe 'BaseCrud:', ->

	beforeEach ->

		@injector = new Injector Mock

		# Mocking
		@modelsProvider = @injector.get ModelsProvider
		@fakeModel = @modelsProvider.__createModel 'FakeResource', field_1: type: Number

		# Setting up code
		@mod = @injector.get BaseCrud
		@mod.resourceName = 'FakeResource'

	afterEach ->
		@modelsProvider.__reset()

	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseCrud

	describe "query()", ->
		it "be a function", -> @mod.query.should.be.a.function
		it "returns a model", -> @mod.query().should.equal @fakeModel

	describe "read()", ->
		beforeEach ->
			Q.all [
				new @fakeModel(field_1: 100).saveQ()
				new @fakeModel(field_1: 1000).saveQ()
				new @fakeModel(field_1: 10).saveQ()
				new @fakeModel(field_1: 1001).saveQ()
			]


		it "is function", -> @mod.read.should.be.a.Function
		it "reads", -> @mod.read()
		it "filters", (done) ->
			@mod.read null, field_1: 1000, null
			.done (docs) ->
				docs[0].field_1.should.equal 1000
				done()
		it "filters for owners", (done) ->
			@mod.read null, field_1: 1000, null
			.done (docs) ->
				docs[0].field_1.should.equal 1000
				done()