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
		mod = injector.get CrudFactory

	afterEach -> mod._init.restore()

	it "exist", -> mod.should.exist
	it 'calls _init()', -> mod._init.called.should.be.ok
	it 'sets loaders/glob', ->
		mod.loader.globPromise.globProvider.should.equal glob


	describe '_init()', ->
		beforeEach ->
			sinon.spy mod.loader, 'load'
			sinon.spy mod, '_onLoad'

		it 'exist', -> mod._init.should.be.a.Function
		it 'loads cruds', ->
			mod._init()
			mod.loader.load.calledWith 'crud', ['BaseCrud.coffee']
			.should.be.ok

		it 'then _onLoad', (async)->
			mod._init()
			.done ->
				mod._onLoad.calledWith
					Aa: '../cruds/Aa-required'
					bb: '../cruds/bb-required'
				.should.be.ok
				async()
			glob._resolve null, ['Aa', 'bb']


	describe "_onLoad()", ->
		it "exist", -> mod._onLoad.should.be.a.Function
		it "reduce", ->
			class A
			class B
			class C
			cruds = mod._onLoad {A,B,C}
			cruds.A.should.be.instanceof A
			cruds.B.should.be.instanceof B
			cruds.C.should.be.instanceof C

	describe '_instantiate()', ->
		[ref, A] = 0
		beforeEach ->
			class A
			ref = {}
		it 'exist', -> mod._instantiate.should.be.a.Function
		it 'attach instance', ->
			mod._instantiate ref, A, 'pqr'
			ref.pqr.should.be.an.instanceof A
		it 'inherit instance', ->
			mod._instantiate ref, A, 'pqr'
			ref.pqr.should.be.an.instanceof BaseCrud
		it 'set model'