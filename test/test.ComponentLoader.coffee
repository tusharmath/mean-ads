ComponentLoader = require '../backend/modules/ComponentLoader'
GlobPromise = require '../backend/modules/GlobPromise'
RequireProvider = require './mocks/RequireProviderMock'
GlobProviderMock = require './mocks/GlobProviderMock'
Mocks = require './mocks'
{Injector} = require 'di'

describe 'ComponentLoader', ->
	mod = 0
	beforeEach ->
		injector = new Injector Mocks
		mod = injector.get ComponentLoader

	it "depends on GlobPromise", -> mod.globPromise.should.be.an.instanceof GlobPromise
	it "depends on requireProvider", -> mod.requireProvider.should.be.an.instanceof RequireProvider
	describe "_glob()", ->
		beforeEach ->
			sinon.spy mod.globPromise, 'glob'

		it "exist", -> mod._glob.should.be.a.Function
		it "return promise", -> mod._glob('a').then.should.be.a.Function
		it "call glob", ->
			mod._glob('aaa')
			mod.globPromise.glob.args[0].should.eql ['*Aaa.coffee', cwd: './backend/aaas']

	describe "load", ->
		beforeEach ->
			sinon.spy mod, '_glob'
			sinon.spy mod, '_onLoad'
		it "calls _glob", ->
			mod.load 'aaa'
			mod._glob.calledWith 'aaa'
			.should.be.ok
		it "returns promise", -> mod.load('111').then.should.be.a.Function
		it "passes onLoad", ->
			mod.load('111')
			mod.globPromise.globProvider._resolve null, 'yo'
			mod._onLoad.called.ok

	describe "_onLoad", ->
		it "should filter files", ->
			mod._onLoad


