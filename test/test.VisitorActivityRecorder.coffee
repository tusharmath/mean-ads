MongooseProviderMock = require './mocks/MongooseProviderMock'
{Injector} = require 'di'
describe "VisitorActivityRecorder", ->
	beforeEach ->
		# Injector
		@injector = new Injector [MongooseProviderMock]

		#Models
		@Models = @injector.getModule 'factories.ModelFactory', mock: false

		#Controller
		@mod = @injector.getModule 'modules.VisitorActivityRecorder', mock: false
		@date = @injector.getModule 'providers.DateProvider'

	afterEach ->
		@Models.mongooseP.__reset()

	describe "recordWebActivityQ()", ->
		beforeEach ->
			@date.now.returns new Date 2010, 1, 1
			new @Models.Visitor({}).saveQ()
			.then (@user) =>
		it "is a function", ->
			@mod.recordWebActivityQ.should.be.a 'function'
		it "adds action, thing and timestamp", ->
			@mod.recordWebActivityQ @user._id, 'nivea cream', 'search'
			.then => @Models.Visitor.findByIdQ @user._id
			.should.eventually.have.property 'webActivity'
			.deep.equal [
				action: 1
				thing: 'nivea cream'
				timestamp: new Date 2010, 1, 1
			]
		it "ignores if user-id is not found", ->
			objId = @Models.mongooseP.mongoose.Types.ObjectId();
			@mod.recordWebActivityQ objId, 'nivea cream', 'search'
			.should.eventually.equal null
		it "ignores if action name not found", ->
			@mod.recordWebActivityQ @user._id, 'nivea cream', 'my-poopie'
			.should.eventually.equal null