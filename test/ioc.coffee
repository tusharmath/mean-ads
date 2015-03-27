{Injector} = require 'di'
MochaSuite = require 'mocha/lib/suite'
MongooseProviderMock = require './mocks/MongooseProviderMock'
MongooseProvider = require '../backend/providers/MongooseProvider'
_ = require 'lodash'
exports.resolve = (path, _options) ->
	options =
		mockDb: yes
		basePath: '../backend/'

	_.assign options, _options

	path = options.basePath + path.replace '.', '/'
	Module = require path
	mocks = if options.mockDb then [MongooseProviderMock]  else []
	injector = new Injector mocks
	mod = injector.get Module
	mongo = injector.get MongooseProvider
	afterEach = -> mongo.__reset()
	bindOn: (context) ->
		_.assign context, {mod, afterEach, mongo}
