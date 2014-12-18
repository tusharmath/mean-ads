DispatchStamper = require '../backend/modules/DispatchStamper'
{Injector} = require 'di'
describe 'DispatchStamper:', ->
	beforeEach ->
		# DI
		@injector = new Injector

		#DispatchStamper
		@mod = @injector.get DispatchStamper

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
	describe "appendStamp()", ->





