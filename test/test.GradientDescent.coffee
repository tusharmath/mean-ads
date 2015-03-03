_ = require 'lodash'
{Injector} = require 'di'

describe "GradientDescent", ->
	beforeEach ->
		# Injector
		@injector = new Injector
		@mod = @injector.getModule 'modules.GradientDescent', mock: false
		@_hypothesis = (P, Xi) ->
			throw new MeanError 'x1 should be 1' if Xi[0] isnt 1
			tmp = (cost, Xij, j) -> cost + Xij * P[j]
			_.reduce Xi, tmp, 0
	it "must exist", ->
		@mod.should.exist

	describe "_diffWithHypothesis()", ->
		beforeEach ->
			@P = [0, 0]
			# [X0, X1, X2]
			@X = [[1, 2], [1, 3], [1, 4]]
			@Y = [50, 70, 90]
		it "sample 1", ->
			@mod._diffWithHypothesis @X, @Y, @P, @_hypothesis
			.should.deep.equal [50, 70, 90]
		it "sample 2", ->
			@P = [1, 1]
			@mod._diffWithHypothesis @X, @Y, @P, @_hypothesis
			.should.deep.equal [47, 66, 85]

	describe "_gradientDescent()", ->

		beforeEach ->
			sinon.spy @mod, '_diffWithHypothesis'
			@P = [10, 20]
			# [X0, X1, X2]
			@X = [[1, 2], [1, 3], [1, 4]]
			@Y = [50, 70, 90]
			@al = .01


		it "does not change model params", ->
			@mod._gradientDescent @P, @X, @Y, @_hypothesis, @al
			.should.deep.equal @P

		it "does change model params", ->
			@P = [0, 0]
			[P0, P1] = @mod._gradientDescent @P, @X, @Y, @_hypothesis, @al
			P0.should.be.closeTo 0.7, .01
			P1.should.be.closeTo 2.23, .01

		it "throws if label length doesnt match",  ->
			@Y = [1, 2, 3]
			@X = [[1, 2]]
			expect(=> @mod._gradientDescent @P, @X, @Y, @_hypothesis, @al)
			.to.throw "labels length not matching training data"
