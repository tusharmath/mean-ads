{annotate, Injector, Provide} = require 'di'
describe 'Utils:', ->
	beforeEach ->
		@injector = new Injector

		# Utils
		@mod = @injector.getModule 'Utils', mock: false

		# DateProvider
		@dateP = @injector.getModule 'providers.DateProvider'

	describe "hasSubscriptionExpired()", ->
		beforeEach ->
			@subscription =
				startDate: new Date 2012, 1, 2
				campaign: days: 10

		it "returns expired", ->
			# SubscriptionStartDate: 2 Feb 2012, lasts for 10 days
			# Current Date: 2014, Feb, 1
			@dateP.now.returns new Date 2014, 1, 1
			@mod.hasSubscriptionExpired @subscription
			.should.be.true

		it "returns not expired", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 2010 Feb 1
			@dateP.now.returns new Date 2010, 1, 1
			@mod.hasSubscriptionExpired @subscription
			.should.be.false
		it "returns no if its withing the campaign days", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 5 Feb 2012
			@dateP.now.returns new Date 2012, 1, 5
			@mod.hasSubscriptionExpired @subscription
			.should.be.false

		it "returns yes if it is out of the campaign range", ->
			# SubscriptionStartDate: 2 Feb 2012
			# Current Date: 15 Feb 2012
			@dateP.now.returns new Date 2012, 1, 15
			@mod.hasSubscriptionExpired @subscription
			.should.be.true
