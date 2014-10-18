ControllerFactory = require '../backend/modules/ControllerFactory'
BaseController = require '../backend/controllers/BaseController'
ComponentLoader = require '../backend/modules/ComponentLoader'
Mock = require './mocks'
{Injector, Provider} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
		@loader = @injector.get ComponentLoader
		@mod = @injector.get ControllerFactory

	describe '_onLoad()', ->

		it 'instantiates', ->
			class A
			class B
			ctrls = @mod._onLoad {A, B}
			ctrls.A.should.be.instanceof A
			ctrls.B.should.be.instanceof B

		it 'extends BaseController', ->
			class A
			class B
			ctrls = @mod._onLoad {A, B}
			ctrls.A.should.be.instanceof BaseController
			ctrls.B.should.be.instanceof BaseController

		it 'maintains proto', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}
			.A.me.should.equal 'yoyo'


		it 'sets resource', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}
			.A.resource.should.equal 'A'
