Main = require '../backend/sdk/Main'
WindowProvider = require '../backend/providers/WindowProvider'
CommandExecutor = require '../backend/sdk/CommandExecutor'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
{Injector} = require 'di'

describe "Main", ->
	beforeEach ->
		# Injector
		@injector = new Injector

		#HostNameBuilder
		@host = @injector.get HostNameBuilder
		sinon.spy @host, 'setup'

		# Main
		@mod = @injector.get Main

		# Window
		@window = ma:g: 'http://localhost:8080'
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "setup()", ->
		it "be a function", -> @mod.setup.should.be.a.Function
		it "setups the hostnamebuilder", ->
			@mod.setup()
			@host.setup.called.should.be.ok
		it "overrides the original ma", ->
			@mod.setup()
			@window.ma.should.equal @mod.ma
