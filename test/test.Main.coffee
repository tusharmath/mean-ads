Main = require '../backend/sdk/Main'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "Main", ->
	beforeEach ->
		@injector = new Injector
		@mod = @injector.get Main
		@window = {}
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "setup()", ->
		it "be a function", -> @mod.setup.should.be.a.Function