Main = require '../backend/sdk/Main'
WindowProvider = require '../backend/providers/WindowProvider'
CommandExecutor = require '../backend/sdk/CommandExecutor'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "Main", ->
	beforeEach ->
		# Injector
		@injector = new Injector [HttpProviderMock]

		#HostNameBuilder
		@host = @injector.get HostNameBuilder
		sinon.spy @host, 'setup'

		#CommandExecutor
		@exec = @injector.get CommandExecutor
		sinon.stub @exec, 'execute'

		# Main
		@mod = @injector.get Main

		# Window
		@window = ma:g: 'http://localhost:8080'
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "setup()", ->
		before ->
			sinon.spy Main::, 'ma'
		after ->
			Main::ma.restore()
		it "be a function", -> @mod.setup.should.be.a.Function
		it "setups the hostnamebuilder", ->
			@mod.setup()
			@host.setup.called.should.be.ok
		it "overrides the original ma", ->
			@mod.setup()
			@window.ma.should.equal @mod.ma
		it "executes the commands", ->
			# Queue contains argument objects
			@window.ma.q = [
				['ad', '1234', 'abc']
				['pad', '4321', 'qwerty']
			]
			@mod.setup()
			@exec.execute.callCount.should.equal 2
			@exec.execute.calledWith 'ad', ['1234', 'abc']
			.should.be.ok
		it "shouldnt call if ma object is not present", ->
			delete @window.ma
			@mod.setup()
			@exec.execute.callCount.should.equal 0
		it "context should be static for ma", ->
			@mod.setup()
			@window.ma()
			Main::ma.calledOn @mod
			.should.be.ok
