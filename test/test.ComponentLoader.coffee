ComponentLoader = require '../backend/modules/ComponentLoader'
GlobProvider = require '../backend/providers/GlobProvider'
RequireProvider = require '../backend/providers/RequireProvider'
{Injector} = require 'di'


describe 'ComponentLoader:', ->
	globProvider= requireProvider = testable = injector = {}
	beforeEach ->
		injector = new Injector()

		globProvider = injector.get GlobProvider
		requireProvider = injector.get RequireProvider

		testable = injector.get ComponentLoader



	describe "_glob()", ->

		it "should exist", ->
			testable._glob.should.be.a.Function

		it "should call glob", ->
			callback = sinon.spy()
			globMock = sinon.mock globProvider
			globExpectation = globMock.expects 'glob'
			globExpectation
			.once 1
			.withArgs '*As.coffee', cwd: './backend/ass', callback

			testable._glob 'as', callback
			do globMock.verify
