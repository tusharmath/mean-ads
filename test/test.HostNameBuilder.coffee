HostNameBuilder = require '../backend/sdk/HostNameBuilder'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "HostNameBuilder", ->
	beforeEach ->
		@injector = new Injector [WindowProvider]
		@mod = @injector.get HostNameBuilder
		@window = g: {}
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "getHost()", ->
		beforeEach ->
		it "be a function", -> @mod.getHost.should.be.a.Function
		it "should return hostname with port", ->
			@window.g = 'http://localhost:3000/static/a.js'
			@mod.getHost()
			.should.equal 'localhost:3000'
		it "should return hostname without port", ->
			@window.g = 'http://localhost/static/a.js'
			@mod.getHost()
			.should.equal 'localhost'
		it "should return default hostname", ->
			delete @window.g
			@mod.getHost()
			.should.equal 'app.meanads.com'