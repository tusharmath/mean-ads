ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
{Inject, Injector, annotate} = require 'di'
_ = require 'lodash'
class ControllerFactory
	constructor: (@loader, @injector) ->

	init: ->
		@loader.load 'controller', ['BaseController.coffee']
		.then @_onLoad

	_onLoad: (ctrls) =>
		controllers = {}
		_.each ctrls, (ctrlCtor, ctrlName) =>
			# Settingup BaseController
			baseCtrl = @injector.get BaseCtrl
			baseCtrl.resourceName = ctrlName

			# Swapping
			[_proto, ctrlCtor::] = [ctrlCtor::, baseCtrl]
			_.assign ctrlCtor::, _proto

			controllers[ctrlName] = @injector.get ctrlCtor
			bragi.log 'controller', ctrlName
			undefined
		controllers

annotate ControllerFactory, new Inject ComponentLoader, Injector

module.exports = ControllerFactory
