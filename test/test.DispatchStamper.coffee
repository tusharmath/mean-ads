DispatchStamper = require '../backend/modules/DispatchStamper'
DateProvider = require '../backend/providers/DateProvider'
{Injector} = require 'di'
config = require '../backend/config/config'
describe 'DispatchStamper:', ->
	beforeEach ->
		# DI
		@injector = new Injector

		#DispatchStamper
		@mod = @injector.get DispatchStamper

		# Date Provider
		@date = @injector.get DateProvider
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
			sinon.stub @date, 'createFromValue'
			.throws new Error 'Random uncaught error'
			expect => @mod.parseStamp 'a:1'
			.to.throw "Random uncaught error"

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

			sinon.stub @date, 'now'
			.returns new Date 1001001

			@mockDispatch = subscription: 'asd123NEW'

		it "pushes the timestamp to empty string", ->
			@mod.appendStamp '', @mockDispatch
			.should.equal 'asd123NEW:1001001'

		it "pushes the timestamp to already set stamps", ->
			@mod.appendStamp 'asd456OLD:2002002', @mockDispatch
			.should.equal 'asd456OLD:2002002,asd123NEW:1001001'

		it "removes the first one if maxDispatchStampCount has been achieved",->
			@mod.appendStamp 'a:1,b:2,c:3,d:4', @mockDispatch
			.should.equal 'c:3,d:4,asd123NEW:1001001'

		it "doesnt remove any the stamp count matches maxDispatchStampCount",->
			@mod.appendStamp 'a:1,b:2', @mockDispatch
			.should.equal 'a:1,b:2,asd123NEW:1001001'

		it "updates present timestamps", ->
			@mockDispatch.subscription = 'a'
			@mod.appendStamp 'a:1,b:2', @mockDispatch
			.should.equal 'a:1001001,b:2'

	describe "_updateOrAddNewStamp()", ->
		beforeEach ->
			@mStamps = [
				{subscription: 1, timestamp: 100}
				{subscription: 2, timestamp: 200}
				{subscription: 3, timestamp: 300}
				{subscription: 4, timestamp: 400}
				{subscription: 5, timestamp: 500}
			]
		it "adds a new timestamp", ->
			newStamp = subscription: 6, timestamp: 600
			@mod._updateOrAddNewStamp @mStamps, newStamp
			@mStamps[5].should.equal newStamp
		it "updates old timestamp", ->
			newStamp = subscription: 3, timestamp: 600
			@mod._updateOrAddNewStamp @mStamps, newStamp
			@mStamps[2].timestamp.should.equal 600

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


