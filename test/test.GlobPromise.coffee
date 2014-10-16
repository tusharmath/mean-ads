GlobPromise = require '../backend/modules/GlobPromise'
GlobProviderMock = require './mocks/GlobProviderMock'
should = require 'should'
Mock = require './mocks'
{Injector} = require 'di'


describe 'GlobPromise:', ->
	mod = 0
	beforeEach ->
		injector = new Injector Mock
		mod = injector.get GlobPromise

	it "exist", -> mod.should.exist
	it "depends on globProvider", -> mod.globProvider.should.be.an.instanceof GlobProviderMock

	describe "glob()", ->

		it "be a function", -> mod.glob.should.be.a.Function
		it "returns a promise", -> mod.glob('aaa', {}).then.should.be.a.Function
		it "calls globProvider", ->
			globOpts = a:1
			mod.glob 'aaa', globOpts
			mod.globProvider.glob.calledWith 'aaa', globOpts
			.should.be.ok


		it "should reject on error", (async) ->
			error = new Error 'YO'
			mod.glob 'aaa', {}
			.done (->) , (_err)->
				_err.should.equal error
				async()
			mod.globProvider._resolve error

		it "should resolve on non error types", (async) ->
			error = 'YO'
			mod.glob 'aaa', {}
			.done (res)->
				should.not.exist res
				async()
			mod.globProvider._resolve error

		it "should resolve on success", (async) ->
			res = {}
			mod.glob 'aaa', {}
			.done (_res)->
				_res.should.equal res
				async()
			mod.globProvider._resolve null, res


