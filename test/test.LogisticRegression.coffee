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

	describe "_diffWithHypothesis()", ->
		beforeEach ->
			@P = [0, 0]
			# [X0, X1, X2]
			@X = [[1, 2], [1, 3], [1, 4]]
			@Y = [50, 70, 90]
		it "sample 1", ->
			@mod._diffWithHypothesis @X, @Y, @P
			.should.deep.equal [50, 70, 90]
		it "sample 2", ->
			@P = [1, 1]
			@mod._diffWithHypothesis @X, @Y, @P
			.should.deep.equal [47, 66, 85]

	describe "_gradientDescent()", ->

		beforeEach ->
			@P = [10, 20]
			# [X0, X1, X2]
			@X = [[1, 2], [1, 3], [1, 4]]
			@Y = [50, 70, 90]
			@al = .01

		it "does not change model params", ->
			@mod._gradientDescent @P, @X, @Y, @al
			.should.deep.equal @P

		it "does change model params", ->
			@P = [0, 0]
			[P0, P1] = @mod._gradientDescent @P, @X, @Y, @al
			P0.should.be.closeTo 0.7, .01
			P1.should.be.closeTo 2.23, .01

		it "throws if label length doesnt match",  ->
			@Y = [1, 2, 3]
			@X = [[1, 2]]
			expect(=> @mod._gradientDescent @P, @X, @Y, @al)
			.to.throw "labels length not matching training data"
	describe "train()", ->
		beforeEach ->
			@X = [[1], [2], [3], [4]]
			@Y = [ 11, 21, 31, 41 ]
			sinon.spy @mod, '_gradientDescent'

		it "solves", ->
			@mod.train @X, @Y, 1000, .1
			.predict [5]
			.should.be.closeTo 51, 0.001
		it "inserts x0 as 1", ->
			@X = [[1, 2, 3]]
			@Y = [20]
			@mod.train @X, @Y, 1, .1
			@mod._gradientDescent.calledWith [0, 0 ,0 , 0], [[1, 1, 2, 3]]
			.should.be.ok