HostNameBuilder = require '../backend/sdk/HostNameBuilder'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "HostNameBuilder", ->
	beforeEach ->
		@injector = new Injector [WindowProvider]
		@mod = @injector.get HostNameBuilder
		@window = ma: g: {}
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window
	describe "getHost()", ->
		it "be a function", -> @mod.getHost.should.be.a.Function
		it "should return hostname with port", ->
			@window.ma.g = 'http://localhost:3000/static/a.js'
			@mod.getHost()
			.should.equal 'localhost:3000'
		it "should return hostname without port", ->
			@window.ma.g = 'http://localhost/static/a.js'
			@mod.getHost()
			.should.equal 'localhost'
		it "should return default hostname", ->
			delete @window.ma.g
			@mod.getHost()
			.should.equal 'app.meanads.com'

		it "must cache hostname", ->
			@window.ma.g = 'http://localhost/static/a.js'
			@mod.getHost()
			delete @window.ma.g
			@mod.getHost().should.equal 'localhost'