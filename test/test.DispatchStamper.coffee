DispatchStamper = require '../backend/modules/DispatchStamper'
{Injector} = require 'di'
describe 'DispatchStamper:', ->
	beforeEach ->
		# DI
		@injector = new Injector

		#DispatchStamper
		@mod = @injector.get DispatchStamper

	describe "parseStamp()", ->
		it "returns an obj", ->
			stamp = @mod.parseStamp 'aaa111:120,bbb222:2,ccc333:3334'

			stamp.should.have.property "aaa111"
			.to.deep.equal new Date 120

			stamp.should.have.property "bbb222"
			.to.deep.equal new Date 2

			stamp.should.have.property "ccc333"
			.to.deep.equal new Date 3334




