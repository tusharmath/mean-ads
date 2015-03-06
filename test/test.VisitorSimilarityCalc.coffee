{Injector} = require 'di'
describe "VisitorSimilarityCalc", ->
	beforeEach ->
		injector = new Injector
		@mod = injector.getModule 'calculators.VisitorSimilarityCalc', mock: false
	describe "calc()", ->
		beforeEach ->
			timestamp = new Date 2015, 1, 1
			@testVisitor =
				actions: [
					# Keyword, Action, Timestamp
					# Action 1
					['k1', 1, timestamp]
					['k4', 1, timestamp]
					# Action 0
					['k1', 0, timestamp]
					['k2', 0, timestamp]
					['k3', 0, timestamp]
					['k1', 0, timestamp]
					['k1', 0, timestamp]
				]

		it "returns jSimilarity", ->
			filter =
				keywords: ['k1', 'k4' , 'k5']
			@mod.calc filter, @testVisitor
			.should.deep.equal [1/5, 2/3]
