CrudFactory = require '../backend/modules/CrudFactory'
GlobProvider = require '../backend/providers/GlobProvider'
BaseCrud  =require '../backend/cruds/BaseCrud'
should = require 'should'
Mock = require './mocks'
{Injector} = require 'di'


describe 'CrudFactory:', ->
	mod = {}
	glob = {}
	injector = {}
	beforeEach ->
		injector = new Injector Mock
		sinon.spy CrudFactory::, '_init'
		glob = injector.get GlobProvider
		glob.$expect '*Crud.coffee', [null, ['Aa', 'bb']]
		glob.$expect '*Schema.coffee', [null, {}]
		mod = injector.get CrudFactory

	afterEach -> mod._init.restore()

	# it 'promises', ->
	# 	mod.done ->

	# it "exist", -> mod.should.exist
	# it 'calls _init()', -> mod._init.called.should.be.ok
	# it 'sets loaders/glob', ->
	# 	mod.loader.globPromise.globProvider.should.equal glob


	describe '_init()', ->

		it 'exist', -> mod._init.should.be.a.Function
		it 'loads cruds', (async) ->
			mod._init().done (ref) ->
				ref.should.eql(
					Aa: '../cruds/Aa-required'
					bb: '../cruds/bb-required'
				)
				async()