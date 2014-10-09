ComponentLoader = require '../modules/ComponentLoader'
di = require 'di'
logger = require 'bragi'
q = require 'q'
_ = require 'lodash'
class ControllerFactory
	constructor: (loader) ->
		controllers = {}
		return loader
		.load 'controller', ['BaseController.coffee']
		.then (ctrls) ->
			_.each ctrls, (ctrlCtor, ctrlName) ->
				controllers[ctrlName] = injector.get ctrlCtor
				bragi.log 'controller', ctrlName
			return q.fcall -> controllers

di.annotate ControllerFactory, new di.Inject ComponentLoader
module.exports = ControllerFactory
