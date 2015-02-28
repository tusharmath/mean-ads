{Injector} = require 'di'

describe "LinearRegression", ->
	beforeEach ->
		# Injector
		@injector = new Injector
		@mod = @injector.getModule 'modules.LinearRegression', mock: false
	it "must exist", ->
		@mod.should.exist

	describe "_hypothesis()", ->
		beforeEach ->
			@P = [10, 20, 30]
			@Xi = [1, 20, 30]

		it "should return a value", ->
			@mod._hypothesis @P, @Xi
			.should.equal 1310
	describe "train()", ->
		it "should be a method", ->
			@mod.train.should.be.a 'function'

	describe "predict()", ->
		it "should be a method", ->
			@mod.predict.should.be.a 'function'
