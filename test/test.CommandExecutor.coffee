CommandExecutor = require '../backend/sdk/CommandExecutor'
{Injector} = require 'di'

describe "CommandExecutor", ->
	beforeEach ->
		@injector = new Injector

		@mod = @injector.get CommandExecutor

	describe "register()", ->
		it "be a function", -> @mod.register.should.be.a.Function
		it "adds the command to executables", ->
			exe = ->
			@mod.register 'load-my-gun', exe
			@mod._executables['load-my-gun'].should.equal exe
	describe "execute()", ->
		beforeEach ->
			@lmg1 = execute: sinon.spy()
			@mod.register 'load-my-gun-1', @lmg1
		it "be a function", -> @mod.execute.should.be.a.Function
		it "executes the command.execute method", ->
			@mod.execute 'load-my-gun-1'
			@lmg1.execute.called.should.be.ok
		it "should not throw if command is not register", ->
			expect => @mod.execute 'load-my-gun-2'
			.to.not.throw()
		it "should pass args to execute method", ->
			@mod.execute 'load-my-gun-1', [1,2,3]
			@lmg1.execute.calledWith 1, 2, 3
			.should.be.ok
		it "should throw if args is not in array format", ->
			expect => @mod.execute 'load-my-gun-1', 100
			.to.throw()
		it "should call execute with the action context", ->
			@mod.execute 'load-my-gun-1'
			@lmg1.execute.calledOn @lmg1
			.should.be.ok
		it "should not throw if execute command is not found", ->
			@lmg1 = execute1: sinon.spy()
			@mod.register 'load-my-gun-1', @lmg1
			expect => @mod.execute 'load-my-gun-1'
			.to.not.throw()