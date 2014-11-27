ControllerFactory = require '../backend/factories/ControllerFactory'
BaseController = require '../backend/controllers/BaseController'
Mock = require './mocks'
{Injector, Provide, TransientScope} = require 'di'
Q = require 'q'

describe 'ControllerFactory:', ->
	beforeEach ->
		@injector = new Injector Mock
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

		it 'sets resourceName', ->
			class A
				me: 'yoyo'

			@mod._onLoad {A}
			.A.resourceName.should.equal 'A'

		# it "crud must be available", ->
		# 	class Apple
		# 		me: 'yoyo'
		# 	ctrls = @mod._onLoad {Apple}
		# 	ctrls.Apple.crud.should.equal @crudP.cruds.Apple
	describe "_extend()", ->
		beforeEach ->
			@BaseInstance =
				methodAA: ->
				methodBB: ->

			class @ChildCtor
				methodBB: ->
				methodCC: ->

		it "be a function", -> @mod._extend.should.be.a.Function
		it "has base methods", ->
			@mod._extend @BaseInstance, @ChildCtor
			@injector.get @ChildCtor
			.methodAA.should.equal @BaseInstance.methodAA
		it "has own methods", ->
			@mod._extend @BaseInstance, @ChildCtor
			@injector.get @ChildCtor
			.methodCC.should.equal @ChildCtor::methodCC

		it "overrides base", ->
			@mod._extend @BaseInstance, @ChildCtor
			@injector.get @ChildCtor
			.methodBB.should.equal @ChildCtor::methodBB
