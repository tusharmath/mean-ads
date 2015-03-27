ModelFactory = require '../backend/factories/ModelFactory'
MongooseProvider = require  '../backend/providers/MongooseProvider'
RequireProvider = require  '../backend/providers/RequireProvider'
MongooseProviderMock = require  './mocks/MongooseProviderMock'
{Injector} = require 'di'

describe 'ModelFactory:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]

		# ModelFactory
		@mod = @injector.get ModelFactory

		#Mongoose
		@mongooseP = @injector.get MongooseProvider

		#RequireProvider
		@requireProvider = @injector.get RequireProvider

	afterEach ->
		@mongooseP.__reset()

	describe "reduce()", ->
		beforeEach ->
			MockSchema = (mongoose) ->
				new mongoose.Schema field_1: type: String

			sinon.stub @requireProvider, 'require'
			.returns MockSchema

		it "function", -> @mod._reduce.should.be.a.Function

		it "reduces instance", ->
			@mod._reduce {}, 'woodo'
			.woodo.findById.should.be.a.Function

		it "supports Q", ->
			@mod._reduce {}, 'woodo'
			.woodo.findById(1).execQ.should.be.a.Function
		it "throws an error if resourceName is not provided", ->
			expect => @mod._reduce 'woodo'
			.to.throw 'resourceName is required'


		it "enables saving data", ->
			models = @mod._reduce {}, 'doodo'
			doc = new models.doodo field_1: 'honeySingh'
			doc.saveQ()
			.then ->
				models.doodo.findOne().execQ()
				.should.eventually.have.property '_id'
	describe "this", ->
		it "returns all the models", ->
			@mod.Subscription.should.exist



