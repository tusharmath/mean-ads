RedisConnectionMock = require './mocks/RedisConnectionMock'
{Injector} = require 'di'

describe "SplitTesting", ->
	beforeEach ->
		# Injector
		# TODO: Use global mock
		@injector = new Injector [RedisConnectionMock]
		@mod = @injector.getModule 'modules.SplitTesting', mock: false

		# RequireProvider
		@mockExperiment =
			startDate : new Date 2010, 2, 1
			endDate : new Date 2010, 2, 10
		@requireP = @injector.getModule 'providers.RequireProvider'
		@requireP.require.returns @mockExperiment

		# RedisConnection
		@redis = @injector.getModule 'connections.RedisConnection', mock: false

		# AbTestingProvider
		@ab = @injector.getModule 'providers.AbTestingProvider'

		# DateProvider
		@dateP = @injector.getModule 'providers.DateProvider'
		# Current Date 1 Mar 2010
		@dateP.now.returns new Date 2010, 2, 1


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

			@uuid = 'LW407gJudbDK7rbXm'
			@experimentName = 'valid-experiment'
			@executables = [
				sinon.spy()
				sinon.spy()
				sinon.spy()
			]
		it "returns null is startDate is in future", ->
			# startDate 10 Mar 2010
			@mockExperiment.startDate = new Date 2010, 2, 10
			expect @mod.getExperiment 'alpha', 'bravo'
			.to.be.null
		it "returns null is endDate is in past", ->
			# endDate 10 Feb 2010
			@mockExperiment.endDate = new Date 2010, 1, 10
			expect @mod.getExperiment 'alpha', 'bravo'
			.to.be.null
		it "returns descriptor is in valid date range", ->
			# endDate 10 March 2010
			# startDate 20 Feb 2010
			@mockExperiment.endDate = new Date 2010, 3, 10
			@mockExperiment.startDate = new Date 2010, 1, 20
			@mod.getExperiment 'alpha', 'bravo'
			.should.equal @mockExperiment