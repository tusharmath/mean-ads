require 'mock-promises'
chai = require 'chai'
chai.use require 'chai-datetime'
global.should = chai.should()
global.expect = chai.expect
chai.use require "chai-as-promised" #Used to test Glob
global.bragi =
	log: ->
	util: symbols: {}
global.sinon = require 'sinon'
Q = require 'q'
sinonAsPromised = require('sinon-as-promised') Q.Promise
_ = require 'lodash'
###
	DI Auto Mocker
###

{Injector} = require 'di'
global.Injector = Injector
Injector::getModule = (path, _options = {}) ->
	options =
		mock: yes
		basePath: '../backend/'

	_.assign options, _options
	path = options.basePath + path.replace '.', '/'
	Module = require path
	instance = @get Module
	if options.mock is yes
		_.each Module::, (v, k) ->
			sinon.stub instance, k if typeof v is 'function'
	instance