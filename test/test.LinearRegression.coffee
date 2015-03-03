_ = require 'lodash'
{Injector} = require 'di'

describe "LinearRegression", ->
	beforeEach ->
		# Injector
		@injector = new Injector
		@mod = @injector.getModule 'modules.LinearRegression', mock: false
		@gradient = @injector.getModule 'modules.GradientDescent', mock: false
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
		beforeEach ->
			@X = [[1], [2], [3], [4]]
			@Y = [ 11, 21, 31, 41 ]
			sinon.spy @gradient, 'execute'

		it "solves", ->
			@mod.train @X, @Y, 1000, .1
			.predict [5]
			.should.be.closeTo 51, 0.001
		it "inserts x0 as 1", ->
			@X = [[1, 2, 3]]
			@Y = [20]
			@mod.train @X, @Y, 120, .1
			@mod.gradient.execute.calledWith [0, 0 ,0 , 0], [[1, 1, 2, 3]], @Y, @mod._hypothesis, 120, 0.1
			.should.be.ok