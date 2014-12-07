{Inject, Injector, annotate} = require 'di'
config = require '../config/config'
_ = require 'lodash'
class ControllerFactory
	constructor: (injector) ->
		@Controllers = {}
	 _.each config.resources, (i) =>
	 	@Controllers[i] = injector.get require "../controllers/#{i}Controller"
annotate ControllerFactory, new Inject Injector

module.exports = ControllerFactory
