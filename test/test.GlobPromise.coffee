GlobPromise = require '../backend/modules/GlobPromise'
GlobProviderMock = require './mocks/GlobProviderMock'
GlobProvider = require '../backend/providers/GlobProvider'
should = require 'should'
Mock = require './mocks'
{Injector} = require 'di'


describe 'GlobPromise:', ->
	[mod, glob] = 0
	beforeEach ->
		injector = new Injector Mock
		mod = injector.get GlobPromise
		glob = injector.get GlobProvider

	it "exist", -> mod.should.exist
	it "depends on globProvider", -> mod.globProvider.should.be.an.instanceof GlobProviderMock

	describe "glob()", ->

		it "be a function", -> mod.glob.should.be.a.Function
		it "returns promise", ->
			[p, o] = ['aaa', {}]
			mod.globProvider.$expect p
			mod.glob(p, o).then.should.be.a.Function
		it "calls globProvider", ->
			[p, o] = ['aaa', a:1]
			mod.globProvider.$expect p
			mod.glob p, o
			mod.globProvider.glob.calledWith p, o
			.should.be.ok
		it "rejects on error", (async) ->
			[p, o , error] = ['aaa', {}, new Error 'YO']
			mod.globProvider.$expect p, error
			mod.glob p, o
			.done (->) , (_err)->
				_err.should.equal error
				async()
			mod.globProvider.$flush()

		it "should resolve on non error types", (async) ->
			[p, o , error] = ['aaa', {}, 'YO']
			glob.$expect p, [error]
			mod.glob p, o
			.done (res)->
				should.not.exist res
				async()
			glob.$flush()

		it "resolves on success", (async) ->
			[p, o, res] = ['aaa', {}, {}]
			mod.globProvider.$expect p, null ,res
			mod.glob p, o
			.done (_res)->
				_res.should.equal res
				async()
			mod.globProvider.$flush()


