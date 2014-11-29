BaseCrud = require '../backend/cruds/BaseCrud'
ModelFactory = require '../backend/factories/ModelFactory'
Q = require 'q'
{Provide, Injector} = require 'di'
mockgoose = require 'mockgoose'
mongooseQ = require 'mongoose-q'
mongoose = require 'mongoose'


class MockModelFactory
	constructor: ->
		@Models = {}
		@mongoose = mongooseQ mockgoose mongoose
	__createModel: (name, schemaDefinition) ->
		schema = new mongoose.Schema schemaDefinition
		@Models[name] = @mongoose.model name, schema
	__reset: ->
		mockgoose.reset()
		@mongoose.models = {}

MockModelFactory.annotations = [
	new Provide ModelFactory
]

describe 'BaseCrud:', ->

	beforeEach ->

		@injector = new Injector [MockModelFactory]
		# Setting up code
		@mod = @injector.get BaseCrud
		@modelFac = @injector.get ModelFactory

		# Test setup
		@mod.resourceName = 'FakeResource'
		@modelFac.__createModel 'FakeResource', field_1: Number

	afterEach ->
		@modelFac.__reset()

	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseCrud

	it "sets model property", ->

	describe "read()", ->
		beforeEach ->
			Q.all [
				new @modelFac.Models.FakeResource(field_1: 100).saveQ()
				new @modelFac.Models.FakeResource(field_1: 1000).saveQ()
				new @modelFac.Models.FakeResource(field_1: 10).saveQ()
				new @modelFac.Models.FakeResource(field_1: 1001).saveQ()
			]


		it "is function", -> @mod.read.should.be.a.Function
		it "reads", -> @mod.read()
		it "filters", ->
			@mod.read null, field_1: 10, null
			.then (res)-> res[0].field_1.should.equal 10

	describe "update()", ->
		it "deletes _id", ->
			obj = _id : 100, name: 3000
			sinon.stub @mod.model, 'findByIdAndUpdate'
			.returns execQ: sinon.stub().resolves null

			@mod.update obj
			should.not.exist obj._id

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
			@modelFac.Models = FakeResource: val: 0, execQ: -> Q @val
			@mod.query [1, 2, 3, 4]
			.should.eventually.equal 10
