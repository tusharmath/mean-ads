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
	DI extender
###

{Injector} = require 'di'

_createMock: (module) ->
	class MockModule
	_.each module::, (v, k) ->
		MockModule[k] = sinon.stub() if typeof v is 'function'

Injector::getModule = (path, _options = {}) ->
	options =
		mock: true
		basePath: '../backend/'

	_.assign options, _options
	path = options.basePath + path.replace '.', '/'
	module = require path
	_createMock module if options.mock is true
	@get module