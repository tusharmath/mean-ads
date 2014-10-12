ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
di = require 'di'
logger = require 'bragi'
q = require 'q'
_ = require 'lodash'
class ControllerFactory
	constructor: (loader, @injector) ->
		controllers = {}
		return loader
		.load 'controller', ['BaseController.coffee']
		.then @_onLoad

	_onLoad: (ctrls) =>
		controllers = {}
		_.each ctrls, (ctrlCtor, ctrlName) =>
			ctrlCtor :: = @injector.get BaseCtrl
			controllers[ctrlName] = @injector.get ctrlCtor
			bragi.log 'controller', ctrlName
		return q.fcall -> controllers

di.annotate ControllerFactory, new di.Inject ComponentLoader, di.Injector
module.exports = ControllerFactory
