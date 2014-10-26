CrudFactory = require '../backend/modules/CrudFactory'
ModelsProvider = require '../backend/providers/ModelsProvider'
require 'mock-promises'
Mock = require './mocks'
Q = require 'q'
{Injector} = require 'di'

describe 'CrudFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
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

			sinon.stub @mod.loader, 'load'
			.returns Q.fcall -> {PP, QQ}

			@models = PP:11, QQ:22

			sinon.stub @mod.modelFac, 'init'
			.returns Q.fcall => @models

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
