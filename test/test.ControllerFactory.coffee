ControllerFactory = require '../backend/factories/ControllerFactory'
BaseController = require '../backend/controllers/BaseController'
ComponentLoader = require '../backend/modules/ComponentLoader'
Mock = require './mocks'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	BaseControllerMock = null
	beforeEach ->
		class BaseControllerMock
		BaseControllerMock.annotations = [
			new Provide BaseController
			new TransientScope
		]

		@injector = new Injector [BaseControllerMock].concat Mock
		@loader = @injector.get ComponentLoader
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
			ctrls.A.should.be.instanceof BaseControllerMock
			ctrls.B.should.be.instanceof BaseControllerMock

		it 'maintains proto', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}, A: crudA
			.A.me.should.equal 'yoyo'


		# it 'sets resource', ->
		# 	class A
		# 		me: 'yoyo'

		# 	@mod._onLoad {A}, A: crudA
		# 	.A.resource.should.equal 'A'

		it 'sets resourceName', ->
			crudA = {}
			class A
				me: 'yoyo'

			@mod._onLoad {A}, A: crudA
			.A.resourceName.should.equal 'A'
