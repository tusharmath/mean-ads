{Injector} = require 'di'
config = require '../backend/config/config'
describe 'DispatchStamper:', ->
	beforeEach ->
		# DI
		@injector = new Injector

		#DispatchStamper
		@mod = @injector.getModule 'modules.DispatchStamper', mock: false

		# Date Provider
		@date = @injector.getModule 'providers.DateProvider'
	describe "_getMaxDispatchCount", ->
		it "returns config.maxDispatchStampCount", ->
			@mod._getMaxDispatchCount().should.equal config.maxDispatchStampCount

	describe "parseStamp()", ->
		it "returns an array", ->
			@mod.parseStamp 'aaa111:120,bbb222:2,ccc333:3334'
			.length.should.equal 3
		it "contains subscription", ->
			stamps = @mod.parseStamp 'aaa111:120,bbb222:2,ccc333:3334'
			stamps[0].subscription.should.equal 'aaa111'
		it "contains timestamp", ->
			stamps = @mod.parseStamp 'aaa111:120,bbb222:2,ccc333:3334'
			stamps[0].timestamp.should.be.a 'date'
		it "sets timestamp in date format", ->
			stamps = @mod.parseStamp 'aaa111:120,bbb222:2,ccc333:3334'
			stamps[0].timestamp.should.deep.equal new Date 120
		it "returns empty array if its a mean error", ->
			@mod.parseStamp ''
			.should.deep.equal []
		it "returns empty array if stampStr is null", ->
			@mod.parseStamp null
			.should.deep.equal []
		it "throws if its not a mean error", ->
			expect => @mod.parseStamp 'a:aasd'
			.to.throw "Can not parse dispatch timestamp"

	describe "_reduce()", ->
		it "reduces", ->
			@mod._reduce '', subscription: 'asd123', timestamp: new Date 234123123
			.should.equal 'asd123:234123123'
		it "adds a comma", ->
			@mod._reduce 'lop:098', subscription: 'asd123', timestamp: new Date 234123123
			.should.equal 'lop:098,asd123:234123123'

	describe "appendStamp()", ->
		beforeEach ->
			sinon.stub @mod, '_getMaxDispatchCount'
			.returns 3

			@date.now.returns new Date 1001001

			@mockDispatch = subscription: 'asd123NEW'

		it "pushes the timestamp to empty string", ->
			@mod.appendStamp '', @mockDispatch
			.should.equal 'asd123NEW:1001001'

		it "concatinates with the timestamp to already set stamps", ->
			@mod.appendStamp 'asd456OLD:2002002', @mockDispatch
			.should.equal 'asd123NEW:1001001,asd456OLD:2002002'

		it "removes the first one if maxDispatchStampCount has been achieved",->
			@mod.appendStamp 'a:1,b:2,c:3,d:4', @mockDispatch
			.should.equal 'c:3,d:4,asd123NEW:1001001'

		it "doesnt remove any the stamp count matches maxDispatchStampCount",->
			@mod.appendStamp 'a:1,b:2', @mockDispatch
			.should.equal 'a:1,b:2,asd123NEW:1001001'

		it "updates present timestamps", ->
			@mockDispatch.subscription = 'a'
			@mod.appendStamp 'a:1,b:2', @mockDispatch
			.should.equal 'b:2,a:1001001'

	describe "_updateOrAddNewStamp()", ->
		beforeEach ->
			@mStamps = [
				{subscription: 1, timestamp: 100}
				{subscription: 2, timestamp: 200}
				{subscription: 3, timestamp: 300}
				{subscription: 4, timestamp: 400}
				{subscription: 5, timestamp: 500}
			]

			# Setting the MaxDispatchCount
			sinon.stub @mod, '_getMaxDispatchCount'
			.returns 3

		it "adds a new timestamp", ->
			newStamp = subscription: 6, timestamp: 600
			@mod._updateOrAddNewStamp @mStamps, newStamp
			@mStamps[5].should.equal newStamp
		it "updates old timestamp", ->
			newStamp = subscription: 3, timestamp: 789
			@mod._updateOrAddNewStamp @mStamps, newStamp
			@mStamps[2].timestamp.should.equal 789
		it "converts toString() before checking", ->
			newStamp = subscription: '3', timestamp: 789
			@mod._updateOrAddNewStamp @mStamps, newStamp
			@mStamps[2].timestamp.should.equal 789

	describe "_removeOldStamps()", ->
		beforeEach ->
			@mStamps = [
				{subscription: 3, timestamp: 300}
				{subscription: 2, timestamp: 200}
				{subscription: 1, timestamp: 100}
				{subscription: 5, timestamp: 500}
				{subscription: 4, timestamp: 400}
			]
			# Setting the MaxDispatchCount
			sinon.stub @mod, '_getMaxDispatchCount'
			.returns 3

		it "maintains MaxDispatchCount", ->
			@mod._removeOldStamps @mStamps
			.length.should.equal 3
		it "removes from the oldest timestamps", ->
			@mod._removeOldStamps @mStamps
			.should.deep.equal [
				{subscription: 3, timestamp: 300}
				{subscription: 4, timestamp: 400}
				{subscription: 5, timestamp: 500}
			]
		it "should not remove anything", ->
			@mStamps = [
				{subscription: 'a', timestamp: 1}
				{subscription: 'b', timestamp: 2}
			]
			@mod._removeOldStamps @mStamps
			.should.deep.equal @mStamps

	describe "isConvertableSubscription()", ->
		beforeEach ->
			sinon.stub @mod, '_getConversionMaxAge'
			.returns 20

			@date.now.returns new Date 250

		it "is yes if subscriptionId is present and time hasnt expired", ->
			@mod.isConvertableSubscription "a:1,b:240.c:3", 'b'
			.should.be.true
		it "is no if subscriptionId is NOT present",  ->
			@mod.isConvertableSubscription "a:1,b:2.c:3", 'd'
			.should.be.false
		it "is no if timestamp has expired",  ->
			@mod.isConvertableSubscription "a:1,b:200.c:3", 'b'
			.should.be.false
