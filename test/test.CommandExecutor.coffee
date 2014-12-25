CommandExecutor = require '../backend/sdk/CommandExecutor'
{Injector} = require 'di'

describe "CommandExecutor", ->
	beforeEach ->
		@injector = new Injector

		@mod = @injector.get CommandExecutor

	describe "register()", ->
		it "be a function", -> @mod.register.should.be.a.Function
		it "adds the command to executables", ->
			class Exe
				alias: 'load-my-gun'
			@mod.register Exe
			@mod._executables['load-my-gun'].should.be.an.instanceof Exe
	describe "execute()", ->
		beforeEach ->
			class Lmg1
				alias: 'load-my-gun-1'
				execute: sinon.spy()
			@Lmg1 = Lmg1
			@mod.register @Lmg1

		it "be a function", -> @mod.execute.should.be.a.Function
		it "executes the command.execute method", ->
			@mod.execute 'load-my-gun-1'
			@Lmg1::execute.called.should.be.ok
		it "should not throw if command is not register", ->
			expect => @mod.execute 'load-my-gun-2'
			.to.not.throw()
		it "should pass args to execute method", ->
			@mod.execute 'load-my-gun-1', [1,2,3]
			@Lmg1::execute.calledWith 1, 2, 3
			.should.be.ok
		it "should throw if args is not in array format", ->
			expect => @mod.execute 'load-my-gun-1', 100
			.to.throw()
		it "should call execute with the action context", ->
			@mod.execute 'load-my-gun-1'
			@Lmg1::execute.calledOn @mod._executables['load-my-gun-1']
			.should.be.ok
		it "should not throw if execute command is not found", ->
			class Lmg1
				alias: 'load-my-gun-1'
				execute1: sinon.spy()
			@mod.register Lmg1
			expect => @mod.execute 'load-my-gun-1'
			.to.not.throw()