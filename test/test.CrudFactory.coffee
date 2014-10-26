CrudFactory = require '../backend/factories/CrudFactory'
BaseCrud = require '../backend/cruds/BaseCrud'
Mock = require './mocks'
Q = require 'q'
{TransientScope, Injector, Provide} = require 'di'

describe 'CrudFactory:', ->
	beforeEach ->
		class BaseCrudMock
		BaseCrudMock.annotations = [
			new Provide BaseCrud
			new TransientScope
		]
		@injector = new Injector [BaseCrudMock].concat Mock
		@mod = @injector.get CrudFactory


	it 'init() is function', -> @mod.init.should.be.a.Function

	describe 'init()', ->
		PP = null
		QQ = null
		beforeEach (done)->
			class PP
				alpha: ->

			class QQ
				bravo: ->

			sinon.stub @mod.modelFac, 'init'
			sinon.stub @mod.loader, 'load'
			.returns Q.fcall -> {PP, QQ}

			@mod.init().done (@crud) => done()

		it 'creates instances', ->
			@crud.PP.should.be.an.instanceof PP


		it 'implements inheritence', ->
			@crud.PP.alpha.should.be.a.Function
			@crud.QQ.bravo.should.be.a.Function

		it 'not merge ctros', ->
			should.not.exist @crud.PP.bravo
			should.not.exist @crud.QQ.alpha

		it 'setup resourceName', ->
			@crud.PP.resourceName.should.equal 'PP'
