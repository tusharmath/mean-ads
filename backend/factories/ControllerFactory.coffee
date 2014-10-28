ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
CrudFactory = require './CrudFactory'
{Inject, Injector} = require 'di'
Q = require 'q'
_ = require 'lodash'
class ControllerFactory
	constructor: (@loader, @injector, @crudFac) ->

	init: ->
		Q.all [
			@loader.load 'controller', ['BaseController.coffee']
			@crudFac.init()
		]
		.spread @_onLoad

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

ControllerFactory.annotations = [
	new Inject ComponentLoader, Injector, CrudFactory
]

module.exports = ControllerFactory
