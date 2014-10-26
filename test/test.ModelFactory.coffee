ModelFactory = require '../backend/factories/ModelFactory'
Mock = require './mocks'
{Injector} = require 'di'

describe 'ModelFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get ModelFactory

	afterEach ->
		@mod.db.mongooseProvider.reset 'woodo'

	describe "create()", ->
		MockSchema = null
		beforeEach ->
			MockSchema = (mongoose) ->
				new mongoose.Schema field_1: type: String

		it "function", -> @mod.create.should.be.a.Function
		it "creates instance", ->
			@mod.create 'woodo', MockSchema
			.findById.should.be.a.Function
		it "supports Q", ->
			@mod.create 'woodo', MockSchema
			.findById(1).execQ.should.be.a.Function



