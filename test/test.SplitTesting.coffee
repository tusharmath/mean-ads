RedisConnectionMock = require './mocks/RedisConnectionMock'
{Injector} = require 'di'

describe "SplitTesting", ->
	beforeEach ->
		# Injector
		# TODO: Use global mock
		@injector = new Injector [RedisConnectionMock]

		# RequireProvider
		@requireP = @injector.getModule 'providers.RequireProvider'

		# RedisConnection
		@redis = @injector.getModule 'connections.RedisConnection', mock: false

		# AbTestingProvider
		@scenarioName = 'sample-scenario-name'
		@abExperiment =
			getGroup: => @scenarioName
			test: sinon.spy()
		@ab = @injector.getModule 'providers.AbTestingProvider'
		@ab.abTesting.returns createTest: => @abExperiment

		# DateProvider
		@dateP = @injector.getModule 'providers.DateProvider'
		## Current Date 1 Mar 2010
		@dateP.now.returns new Date 2010, 2, 1

		@mod = @injector.getModule 'modules.SplitTesting', mock: false

	describe "_load(expName)", ->
		beforeEach ->
			@requireP.require.returns 'fake-module'
		it "be a function", -> @mod._load.should.be.a.Function
		it "loads experiment", ->
			@mod._load 'apples'
			.should.equal 'fake-module'
		it "calls require with experiment name", ->
			@mod._load 'alpha-bravo-charlie'
			@requireP.require.calledWith '../experiments/AlphaBravoCharlieExpr'
			.should.be.ok

	describe "_save()", ->
		it "updates command counts counts", ->
			@mod._save 'aaa', 'bbb', 'ccc'
			@redis.conn.get 'aaa:bbb:ccc'
			.should.eventually.equal '1'
	describe "getExperiment()", ->
		beforeEach ->

			@mockExperiment =
				startDate : new Date 2010, 2, 1
				endDate : new Date 2010, 2, 10
				scenarioDescriptors : [
					name: 'a', weight: .5
				,	name: 'b', weight: .5
				]
			@requireP.require.returns @mockExperiment

			@uuid = '915a4c9f-5bde-4b76-a1fe-922943603c13'
			@experimentName = 'valid-experiment-name'

		it "returns null is startDate is in future", ->
			# startDate 10 Mar 2010
			@mockExperiment.startDate = new Date 2010, 2, 10
			expect @mod.getExperiment @experimentName, @uuid
			.to.be.null
		it "returns null is endDate is in past", ->
			# endDate 10 Feb 2010
			@mockExperiment.endDate = new Date 2010, 1, 10
			expect @mod.getExperiment @experimentName, @uuid
			.to.be.null
		it "returns descriptor is in valid date range", ->
			# endDate 10 March 2010
			# startDate 20 Feb 2010
			@mockExperiment.endDate = new Date 2010, 3, 10
			@mockExperiment.startDate = new Date 2010, 1, 20
			@mod.getExperiment @experimentName, @uuid
			.should.equal @mockExperiment
		it "attaches execute method", ->
			@mod.getExperiment @experimentName, @uuid
			.execute cb = [1,2,3]
			@abExperiment.test.calledWith @scenarioName, cb
			.should.be.ok
		it "execute method calls save", ->
			sinon.spy @mod, '_save'
			@mod.getExperiment @experimentName, @uuid
			.execute cb = [1,2,3]
			@mod._save.calledWith @experimentName, @scenarioName, 'execute'
		it "convert method calls save", ->
			sinon.spy @mod, '_save'
			@mod.getExperiment @experimentName, @uuid
			.convert cb = [1,2,3]
			@mod._save.calledWith @experimentName, @scenarioName, 'convert'


