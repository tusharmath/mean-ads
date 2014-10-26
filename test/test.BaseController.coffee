BaseController = require '../backend/controllers/BaseController'
CrudsProvider = require '../backend/providers/CrudsProvider'
Mock = require './mocks'
{Injector, Provide} = require 'di'


describe 'BaseController:', ->
	beforeEach ->
		class CrudsProviderMock
		CrudsProviderMock.annotations = [
			new Provide CrudsProvider
		]
		@injector = new Injector [CrudsProviderMock].concat Mock
		@mod = @injector.get BaseController

	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseController