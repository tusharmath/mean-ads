HostNameBuilder = require '../backend/sdk/HostNameBuilder'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "HostNameBuilder", ->
	beforeEach ->
		@injector = new Injector [WindowProvider]
		@mod = @injector.get HostNameBuilder
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns {}

	describe "getHost()", ->
		beforeEach ->
		it "be a function", -> @mod.getHost.should.be.a.Function