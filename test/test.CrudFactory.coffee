CrudFactory = require '../backend/modules/CrudFactory'
GlobProviderMock = require './mocks/GlobProviderMock'
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
		glob = injector.get GlobProviderMock
		mod = injector.get CrudFactory

	afterEach -> mod._init.restore()

	it "exist", -> mod.should.exist
	it 'calls _init()', -> mod._init.called.should.be.ok
	it 'sets loaders/glob', ->
		console.log glob.constructor
		mod.loader.globPromise.globProvider.should.equal glob


	describe '_init()', ->
		beforeEach ->
			sinon.spy mod.loader, 'load'

		it 'exist', -> mod._init.should.be.a.Function
		it 'loads cruds', ->
			mod._init()
			mod.loader.load.calledWith 'crud', ['BaseCrud.coffee']
			.should.be.ok

		# it 'attach crudCtors', (async)->
		# 	mod._init()
		# 	.done ->
		# 		mod.crudCtors.should.eql
		# 			Aa: 'aa-ctor'
		# 			Bb: 'bb-ctor'
		# 		async()
		# 	glob._resolve null, ['aa', 'bb']
