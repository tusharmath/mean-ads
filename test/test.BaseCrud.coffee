BaseCrud = require '../backend/cruds/BaseCrud'
Mock = require './mocks'
{Injector} = require 'di'


describe 'BaseController:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get BaseCrud

	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseCrud