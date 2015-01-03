require 'coffee-errors'
require 'mock-promises'
chai = require 'chai'
chai.use require 'chai-datetime'
global.should = chai.should()
global.expect = chai.expect
chai.use require "chai-as-promised" #Used to test Glob
global.bragi = require 'bragi'
global.bragi.options.groupsEnabled = false
global.sinon = require 'sinon'
Q = require 'q'
sinonAsPromised = require('sinon-as-promised') Q.Promise
_ = require 'lodash'
###
	DI Auto Mocker
###

{Injector} = require 'di'

_createMock = (Module) ->
	class MockModule
	_.each Module::, (v, k) ->
		MockModule::[k] = sinon.stub() if typeof v is 'function'
	MockModule

Injector::getModule = (path, _options = {}) ->
	options =
		mock: true
		basePath: '../backend/'

	_.assign options, _options
	path = options.basePath + path.replace '.', '/'
	Module = require path
	if options.mock is true
		Module = _createMock Module
	@get Module