{Inject, Injector, annotate} = require 'di'
{resources} = require '../config/config'
_ = require 'lodash'
class ControllerFactory
	constructor: (injector) ->
		@Controllers = {}
		resources = resources.concat ['Experiment']
		_.each resources, (i) =>
			@Controllers[i] = injector.get require "../controllers/#{i}Controller"
annotate ControllerFactory, new Inject Injector

module.exports = ControllerFactory
