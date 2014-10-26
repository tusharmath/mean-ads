ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
CrudFactory = require './CrudFactory'
{Inject, Injector} = require 'di'
logger = require 'bragi'
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

	_onLoad: (ctrls, cruds) =>
		controllers = {}
		_.each ctrls, (ctrlCtor, ctrlName) =>
			ctrlCtor :: = _.assign @injector.get(BaseCtrl), ctrlCtor::
			controllers[ctrlName] = @injector.get ctrlCtor
			# controllers[ctrlName].resource = ctrlName
			#TODO: This should be added as a depenendency
			controllers[ctrlName].crud = cruds[ctrlName]
			bragi.log 'controller', ctrlName
			undefined
		controllers

ControllerFactory.annotations = [
	new Inject ComponentLoader, Injector, CrudFactory
]

module.exports = ControllerFactory
