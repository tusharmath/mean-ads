CreateImageElement = require '../backend/sdk/CreateImageElement'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "CreateImageElement", ->
	beforeEach ->
		@injector = new Injector

		# CreateImageElement
		@mod = @injector.get CreateImageElement

		# WindowProvider
		@img = {}
		@window = document: createElement: sinon.stub().returns @img
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "create()", ->
		it "creates an image element", ->
			@mod.create 'http://abs.com'
			@window.document.createElement.calledWith 'img'
			.should.be.ok
		it "does not call the callback", ->
			@mod.create 'http://abs.com'
			expect => @img.onload()
			.to.not.throw()
		it "calls the callback", ->
			@mod.create 'http://abs.com', callback = sinon.spy()
			@img.onload()
			callback.called.should.be.ok
