{Injector} = require 'di'

describe "FeatureScaler", ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.getModule 'modules.FeatureScaler', mock: false
		@vectorList = [
			[10, 300]
			[20, 10]
		]

	describe "scaleList()", ->
		it "scales the array", ->
			@mod.scaleList [10, 20, 30, 40, 50]
			.should.deep.equal [-0.5, -0.25, 0, 0.25, 0.5]
	describe "getScaleParams()", ->
		it "get scaling parameters", ->
			@mod.getScaleParams @vectorList
			.should.deep.equal [
				{avg: 15, range: 10}
				{avg: 155, range: 290}
			]
		it "sets range as 1 if max and min are eq", ->
			@vectorList = [
				[10, 300]
				[10, 200]
			]
			@mod.getScaleParams @vectorList
			.should.deep.equal [
				{avg: 10, range: 1}
				{avg: 250, range: 100}
			]
	describe "scaleVectorList()", ->
		beforeEach ->
			@scaleParams = [
				{avg: 15, range: 10}
				{avg: 155, range: 290}
			]
		it "scales the vectorList", ->
			@mod.scaleVectorList @vectorList, @scaleParams
			.should.deep.equal [
				[-0.5, 0.5]
				[0.5, -0.5]
			]
