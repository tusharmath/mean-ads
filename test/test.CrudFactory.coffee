CrudFactory = require '../backend/factories/CrudFactory'
BaseCrud = require '../backend/cruds/BaseCrud'
ModelsProvider = require '../backend/providers/ModelsProvider'
Mock = require './mocks'
Q = require 'q'
{TransientScope, Injector, Provide} = require 'di'

describe 'CrudFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get CrudFactory
		@modelP = @injector.get ModelsProvider


	it 'init() is function', -> @mod.init.should.be.a.Function

	describe 'init()', ->
		PP = null
		QQ = null
		beforeEach (done)->
			class PP
				alpha: ->

			class QQ
				bravo: ->

			sinon.stub @mod.modelF, 'init'
			sinon.stub @mod.loader, 'load'
			.returns Q.fcall -> {PP, QQ}

			@mod.init().done (@crud) => done()

		it 'creates instances', ->
			@crud.PP.should.be.an.instanceof PP
			@crud.PP.should.be.an.instanceof BaseCrud


		it 'implements inheritence', ->
			@crud.PP.alpha.should.be.a.Function
			@crud.QQ.bravo.should.be.a.Function

		it 'not merge ctros', ->
			should.not.exist @crud.PP.bravo
			should.not.exist @crud.QQ.alpha

		it 'setup resourceName', ->
			@crud.PP.resourceName.should.equal 'PP'

		it "sets up CrudsProvider", ->
			should.exist @mod.crudsP.cruds

		it "sets up model", ->
			@modelP.__createModel 'PP', {}
			@mod.crudsP.cruds.PP.model.should.equal @modelP.models.PP

