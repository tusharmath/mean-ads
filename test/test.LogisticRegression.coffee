{Injector} = require 'di'

describe "LinearRegression", ->
	beforeEach ->
		# Injector
		@injector = new Injector
		@mod = @injector.getModule 'modules.LinearRegression', mock: false
	it "must exist", ->
		@mod.should.exist

	describe "train()", ->
		it "should be a method", ->
			@mod.train.should.be.a 'function'

	describe "predict()", ->
		it "should be a method", ->
			@mod.predict.should.be.a 'function'
