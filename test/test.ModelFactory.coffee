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

	describe "create()", ->
		beforeEach ->
			MockSchema = (mongoose) ->
				new mongoose.Schema field_1: type: String

			sinon.stub @requireProvider, 'require'
			.returns MockSchema

		it "function", -> @mod.create.should.be.a.Function

		it "creates instance", ->
			@mod.create {}, 'woodo'
			.woodo.findById.should.be.a.Function

		it "supports Q", ->
			@mod.create {}, 'woodo'
			.woodo.findById(1).execQ.should.be.a.Function
		it "throws an error if resourceName is not provided", ->
			expect => @mod.create 'woodo'
			.to.throw 'resourceName is required'


		it "enables saving data", ->
			models = @mod.create {}, 'doodo'
			doc = new models.doodo field_1: 'honeySingh'
			doc.saveQ()
			.then ->
				models.doodo.findOne().execQ()
				.should.eventually.have.property '_id'
	describe "models()", ->
		it "returns all the models", ->
			@mod.models().Subscription.should.exist
		it "it returns the same models", ->
			model1 = @mod.models()
			model2 = @mod.models()
			model1.should.equal model2



