ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
di = require 'di'
logger = require 'bragi'
Q = require 'q'
_ = require 'lodash'
class ControllerFactory
	constructor: (@loader, @injector) ->

	init: ->
		@baseCtrl = @injector.get BaseCtrl
		Q.all [
			@loader.load 'controller', ['BaseController.coffee']
			@baseCtrl.init()
		]
		.spread @_onLoad

	_onLoad: (ctrls) =>
		controllers = {}
		_.each ctrls, (ctrlCtor, ctrlName) =>
			ctrlCtor :: = _.assign @injector.get(BaseCtrl), ctrlCtor::
			controllers[ctrlName] = @injector.get ctrlCtor
			controllers[ctrlName].resource = ctrlName
			bragi.log 'controller', ctrlName
			undefined
		controllers

di.annotate ControllerFactory, new di.Inject ComponentLoader, di.Injector
module.exports = ControllerFactory
