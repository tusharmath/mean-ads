CrudFactory = require '../backend/modules/CrudFactory'
require 'mock-promises'
Mock = require './mocks'
Q = require 'q'
{Injector} = require 'di'

describe 'CrudFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get CrudFactory

	describe '_ctorReducer()', ->
		beforeEach ->
			@mod.models = {} #TODO: Move the tests to init

		it 'function', -> @mod._ctorReducer.should.be.a.Function

		it 'creates instances', ->
			class A
			@mod._ctorReducer {}, A, 'A'
			.A.should.be.an.instanceof A

		it 'implements inheritence', ->
			class A
				alpha: ->
			class B
				bravo: ->
			instances = @mod._onLoad {A, B}
			instances.A.alpha.should.be.a.Function
			instances.B.bravo.should.be.a.Function

		it 'not merge ctros', ->
			class A
				alpha: ->
			class B
				bravo: ->
			instances = @mod._onLoad {A, B}
			should.not.exist instances.A.bravo
			should.not.exist instances.B.alpha

		it 'sets models', ->
			class A
				alpha: ->
			mockModels = {A: 'aaaa'}
			instances = @mod._onLoad {A}, mockModels
			instances.A.models.should.equal mockModels

	describe 'init', ->
		beforeEach ->
			class PP
				alpha: ->

			class QQ
				bravo: ->

			sinon.stub @mod.loader, 'load'
			.returns Q.fcall -> {PP, QQ}
			@models = PP:11, QQ:22
			sinon.stub @mod.modelFac, 'init'
			.returns Q.fcall => @models

		it 'setup model(s)', (done) ->
			@mod.init().done (crud) =>
				crud.PP.models.should.equal @models
				done()

		it 'setup model', (done) ->
			@mod.init().done (crud) =>
				crud.PP.model.should.equal @models.PP
				done()
