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

	describe "load()", ->
		beforeEach ->
			sinon.spy mod, '_glob'
			sinon.spy mod, '_onLoad'

		it "calls _glob", ->
			mod.load 'type-param'
			mod._glob.calledWith 'type-param'
			.should.be.ok
		it "returns promise", -> mod.load('type-param').then.should.be.a.Function
		it "resolves to onLoad", (async) ->
			ignored = ['ignored-param-file-1']
			mod.load 'type-param', ignored
			.done ->
				mod._onLoad.calledWith 'type-param', ignored, ['response-file-1']
				.should.be.ok
				do async
			mod.globPromise.globProvider._resolve null, ['response-file-1']


	describe "_onLoad()", ->
		it 'resolve files', ->
			ignored = ['cc', 'bb']
			mod._onLoad 'type-param', ignored, ['aa', 'bb', 'cc', 'Dd']
			.should.eql
				aa: '../type-params/aa-required'
				Dd: '../type-params/Dd-required'
