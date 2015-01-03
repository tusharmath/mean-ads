SplitTesting = require '../backend/modules/SplitTesting'
mocks = require './mocks'
{Injector} = require 'di'

describe "SplitTesting", ->
	beforeEach ->
		# Injector
		# TODO: Use global mock
		@injector = new Injector [RedisConnectionMock]
		@mod = @injector.getModule 'modules.SplitTesting', mock: false

		# RequireProvider
		@requireP = @injector.getModule 'providers.RequireProvider'

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
