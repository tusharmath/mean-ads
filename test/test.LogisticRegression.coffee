_ = require 'lodash'
{Injector} = require 'di'

describe "LogisticRegression", ->
	beforeEach ->
		# Injector
		@injector = new Injector
		@mod = @injector.getModule 'modules.LogisticRegression', mock: false
		@gradient = @injector.getModule 'modules.GradientDescent', mock: false
	it "must exist", ->
		@mod.should.exist

	describe "_hypothesis()", ->
		beforeEach ->
			@P = [0, 0, 0]
			@Xi = [1, 20, 30]

		it "should return 1", ->
			@P = [1, 1, 1]
			@mod._hypothesis @P, @Xi
			.should.equal 1

		it "should return 0.5", ->
			@mod._hypothesis @P, @Xi
			.should.equal 0.5
		it "should return 0", ->
			@P = [0, 10, -20]
			@Xi = [1, -20, 30]
			@mod._hypothesis @P, @Xi
			.should.equal 0


	describe "train()", ->
		beforeEach ->
			@X = [1...100].map (i) -> [i]
			@Y = [ 1...100].map (i)-> if i > 50 then 1 else 0
			sinon.spy @gradient, 'train'

		it "solves for 82", ->
			@mod.train @X, @Y, 1000, .1
			.predict [82]
			.should.be.greaterThan 0.5
		it "solves for 0.2", ->
			@mod.train @X, @Y, 1000, .1
			.predict [1]
			.should.be.lessThan 0.5