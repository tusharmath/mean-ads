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
		it "throws if setup has not been called", ->
			expect =>@mod.getHost()
			.to.throw 'setup the HostNameBuilder first dude!'

	describe "setup()", ->
		it "be a function", -> @mod.setup.should.be.a.Function
		it "should return hostname with port", ->
			@window.ma.g = '//localhost:3000/static/a.js'
			@mod.setup()
			.should.equal 'localhost:3000'
		it "should return hostname without port", ->
			@window.ma.g = '//localhost/static/a.js'
			@mod.setup()
			.should.equal 'localhost'
		it "should return hostname without protocol", ->
			@window.ma.g = '//localhost/static/a.js'
			@mod.setup().should.equal 'localhost'
		it "should return default hostname", ->
			delete @window.ma.g
			@mod.setup()
			.should.equal 'app.meanads.com'

		it "must cache hostname", ->
			@window.ma.g = '//localhost/static/a.js'
			@mod.setup()
			delete @window.ma.g
			@mod.setup().should.equal 'localhost'