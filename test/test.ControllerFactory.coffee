ControllerFactory = require '../backend/factories/ControllerFactory'
BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
		@crudP = @injector.get CrudsProvider
		@crudP.cruds = Apple: {}
		@mod = @injector.get ControllerFactory

	describe '_onLoad()', ->
		crudA = 0
		beforeEach: ->
			crudA = {}

		it 'instantiates', ->
			class A
			class B
			ctrls = @mod._onLoad {A, B}, A: crudA
			ctrls.A.should.be.instanceof A
			ctrls.B.should.be.instanceof B

		it 'extends BaseController', ->
			class A
			class B
			ctrls = @mod._onLoad {A, B}, A: crudA
			ctrls.A.should.be.instanceof BaseController
			ctrls.B.should.be.instanceof BaseController

		it 'maintains proto', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}, A: crudA
			.A.me.should.equal 'yoyo'

		it 'sets resourceName', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}
			.A.resourceName.should.equal 'A'

		it "crud must be available", ->
			class Apple
				me: 'yoyo'
			ctrls = @mod._onLoad {Apple}
			ctrls.Apple.crud.should.equal @crudP.cruds.Apple
