ComponentLoader = require '../backend/Modules/ComponentLoader'
Mocks = require './mocks'
{Injector} = require 'di'
describe 'ComponentLoader', ->
	testable = injector = {}
	beforeEach ->
		console.log Mocks
		injector = new Injector Mocks
		testable = injector.get ComponentLoader

	it 'should use mock require', ->
		testable.requireProvider.require('xyz').should.equal 'xyz-module'

	it 'should use mock glob', -> testable.globProvider.glob.should.be.a.Function
