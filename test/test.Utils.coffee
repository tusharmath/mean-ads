{annotate, Injector, Provide} = require 'di'
utils = do require '../backend/Utils'
describe 'Utils:', ->
	beforeEach ->
		@injector = new Injector

		# Utils
		@mod = utils
	### TODO: Remove - subscriptions dont expire
	describe "hasSubscriptionExpired()", ->
		beforeEach ->
			@subscription =
				startDate: new Date 2012, 1, 2
				campaign: days: 10

		it "returns expired", ->
			# SubscriptionStartDate: 2 Feb 2012, lasts for 10 days
			# Current Date: 2014, Feb, 1
			now = new Date 2014, 1, 1
			@mod.hasSubscriptionExpired @subscription, now
			.should.be.true

		it "returns not expired", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 2010 Feb 1
			now = new Date 2010, 1, 1
			@mod.hasSubscriptionExpired @subscription, now
			.should.be.false
		it "returns no if its withing the campaign days", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 5 Feb 2012
			now = new Date 2012, 1, 5
			@mod.hasSubscriptionExpired @subscription, now
			.should.be.false

		it "returns yes if it is out of the campaign range", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 15 Feb 2012
			now = new Date 2012, 1, 15
			@mod.hasSubscriptionExpired @subscription, now
			.should.be.true
		it "throws if now is not provided", ->
			expect => @mod.hasSubscriptionExpired @subscription, 12312
			.to.throw 'now should be of date type'
	###
	describe "camelCasetoSnakeCase()", ->
		it "ABC to abc", ->
			@mod.camelCaseToSnakeCase 'ABC'
			.should.equal 'a-b-c'
		it "AbcDef to abc-def", ->
			@mod.camelCaseToSnakeCase 'AbcDef'
			.should.equal 'abc-def'
		it "abcDef to abc-def", ->
			@mod.camelCaseToSnakeCase 'abcDef'
			.should.equal 'abc-def'
	describe "snakeCasetoCamelCase()", ->
		it "abc to Abc", ->
			@mod.snakeCaseToCamelCase 'abc'
			.should.equal 'Abc'
		it "abc-def to AbcDef", ->
			@mod.snakeCaseToCamelCase 'abc-def'
			.should.equal 'AbcDef'
		it "--abc---def---- to AbcDef", ->
			@mod.snakeCaseToCamelCase '--abc---def----'
			.should.equal 'AbcDef'
	describe "getType()", ->
		it "returns date", ->
			@mod.getType new Date
			.should.equal 'Date'
		it "returns number", ->
			@mod.getType 12345
			.should.equal 'Number'
		it "returns string", ->
			@mod.getType 'qwerty'
			.should.equal 'String'
		it "returns null", ->
			expect @mod.getType null
			.to.equal 'null'
		it "returns undefined", ->
			expect @mod.getType undefined
			.to.equal 'undefined'
	describe "jaccardianSimilarity()", ->
		it "returns 0.5", ->
			@mod.jSimilarity ['a', 'b', 'c'], ['a', 'b', 'd']
			.should.equal 0.5
		it "returns 0.5", ->
			@mod.jSimilarity ['a', 'b', 'c'], ['a', 'b']
			.should.equal 2/3
