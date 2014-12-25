CreateImageElement = require '../backend/sdk/CreateImageElement'
WindowProvider = require '../backend/providers/WindowProvider'
{Injector} = require 'di'

describe "CreateImageElement", ->
	beforeEach ->
		@injector = new Injector

		# CreateImageElement
		@mod = @injector.get CreateImageElement

		# WindowProvider
		@window = document: createElement: sinon.stub().returns {}
		@windowP = @injector.get WindowProvider
		sinon.stub @windowP, 'window'
		.returns @window

	describe "create()", ->
		it "creates an image element", ->
			@mod.create 'http://abs.com'
			@window.document.createElement.calledWith 'img'
			.should.be.ok