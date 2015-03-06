MongooseProviderMock = require './mocks/MongooseProviderMock'
{Injector} = require 'di'
describe "UserActivityRecorder", ->
	beforeEach ->
		# Injector
		@injector = new Injector [MongooseProviderMock]

		#Models
		@modelFac = @injector.getModule 'factories.ModelFactory', mock: false
		@Models = @modelFac.models()

		#Controller
		@mod = @injector.getModule 'modules.UserActivityRecorder', mock: false
		@date = @injector.getModule 'providers.DateProvider'

	afterEach ->
		@modelFac.mongooseP.__reset()

	describe "recordWebActivityQ()", ->
		beforeEach ->
			@date.now.returns new Date 2010, 1, 1
			new @Models.UserActivity({}).saveQ()
			.then (@user) =>
		it "is a function", ->
			@mod.recordWebActivityQ.should.be.a 'function'
		it "adds action, thing and timestamp", ->
			@mod.recordWebActivityQ @user._id, 'nivea cream', 'search'
			.then => @Models.UserActivity.findByIdQ @user._id
			.should.eventually.have.property 'webActivity'
			.deep.equal [
				action: 1
				thing: 'nivea cream'
				timestamp: new Date 2010, 1, 1
			]
		it "ignores if user-id is not found", ->
			objId = @modelFac.mongooseP.mongoose.Types.ObjectId();
			@mod.recordWebActivityQ objId, 'nivea cream', 'search'
			.should.eventually.equal null
		it "ignores if action name not found", ->
			@mod.recordWebActivityQ @user._id, 'nivea cream', 'my-poopie'
			.should.eventually.equal null