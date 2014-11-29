{Provide, Injector} = require 'di'
CrudsProvider = require '../backend/providers/CrudsProvider'
BaseCrud = require '../backend/cruds/BaseCrud'

describe "CrudsProvider:", ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get CrudsProvider

	it "should stay",  ->
		@mod.should.exist

	describe "with()", ->
		it "be a function", ->
			@mod.with.should.be.a.Function

		it "returns an instance of baseCrud", ->
			@mod.with('apple').should.be.an.instanceof BaseCrud

		it "sets crud resourceName", ->
			@mod.with('Apple')
			.resourceName.should.equal 'Apple'
		it "throws no resourcename",  ->
			expect => @mod.with()
			.to.Throw 'resourceName has not been set'
