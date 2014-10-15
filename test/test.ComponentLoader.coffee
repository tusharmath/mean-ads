ComponentLoader = require '../backend/modules/ComponentLoader'
GlobPromise = require '../backend/modules/GlobPromise'
RequireProvider = require './mocks/RequireProviderMock'
Mocks = require './mocks'
{Injector} = require 'di'

describe 'ComponentLoader', ->
	testable = 0
	beforeEach ->
		injector = new Injector Mocks
		testable = injector.get ComponentLoader

	it "depends on GlobPromise", -> testable.globPromise.should.be.an.instanceof GlobPromise
	it "depends on requireProvider", -> testable.requireProvider.should.be.an.instanceof RequireProvider
	describe "_glob()", ->
		it "should exist", -> testable._glob.should.be.a.Function

