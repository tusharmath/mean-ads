_ = require 'lodash'
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


	describe "_gradientDecent()", ->
		beforeEach ->
			@P = [10, 20]
			# [X0, X1, X2]
			@X = [[1, 2], [1, 3], [1, 4]]
			@Y = [50, 70, 90]
			@al = .01
		it "does not change model params", ->
			@mod._gradientDescent @P, @X, @Y, @al
			.should.deep.equal @P
		it "throws if label length doesnt match",  ->
			@Y = [1, 2, 3]
			@X = [[1, 2]]
			expect(=> @mod._gradientDescent @P, @X, @Y, @al)
			.to.throw "labels length not matching training data"
	describe "train()", ->
		X = [[1], [2], [3], [4]]
		Y = [ 11, 21, 31, 41 ]
		beforeEach ->
			sinon.spy @mod, '_gradientDescent'

		it "solves", ->
			@mod.train X, Y, 10000, .1
			.predict [5]
			.should.be.below 51
			.and.above 50
		it "inserts x0 as 1", ->
			@X = [[1, 2, 3]]
			@Y = [20]
			@mod.train @X, @Y, 10000, .1
			@mod._gradientDescent.calledWith [0, 0 ,0 , 0], [[1, 1, 2, 3]]
			.should.be.ok

