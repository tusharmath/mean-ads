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
	describe "update()", ->
		it "deletes _id", ->
			obj = _id : 100, name: 3000
			sinon.stub @mod.model, 'findByIdAndUpdate'
			.returns execQ: sinon.stub().resolves null

			@mod.update obj
			should.not.exist obj._id

		it "calls postupdate", ->
			obj = a:1, b:2, c:3
			sinon.spy @mod, 'postUpdate'
			sinon.stub @mod.model, 'findByIdAndUpdate'
			.returns execQ: sinon.stub().resolves obj

			@mod.update {}
			.then =>
				@mod.postUpdate.calledWith obj
				.should.be.ok


	describe "_reduceQuery()", ->

		it "be a function", -> @mod._reduceQuery.should.be.a.function

		it 'calls query methods', ->
			query = where: sinon.spy()
			@mod._reduceQuery query, where: a: 1000
			query.where.calledWith a: 1000
			.should.be.ok

		it 'calls query methods of no args', ->
			query = where: -> 8000
			@mod._reduceQuery query, 'where'
			.should.equal 8000

		it 'returns query methods response', ->
			query = where: -> 120
			@mod._reduceQuery query, where: a: 1000
			.should.equal 120

	describe 'query', ->
		it 'be a function', ->
			@mod.query.should.be.a.Function
		it 'reduces queries', ->
			sinon.stub @mod, '_reduceQuery', (acc, val) ->
				acc.val += val
				acc
			@mod.Models.FakeResource = val: 0, execQ: -> Q @val
			@mod.query [1, 2, 3, 4]
			.should.eventually.equal 10
