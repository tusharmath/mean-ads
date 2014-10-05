express = require 'express'
config = require '../config/config'
_ = require 'lodash'
ComponentLoader = require '../modules/ComponentLoader'
di = require 'di'
logger = require 'bragi'
{actionMap} = require './conventions'

class V1
	constructor: (loader) ->
		@router = express.Router()
		controllers = loader.load 'controller'
		# controllers = ctrlManager.controllers
		# console.log controllers
		_.each controllers, (ctrlCtor, ctrlName) =>
			ctrl = injector.get ctrlCtor
			_.forIn ctrl, (action, actionName) =>
				if actionName[0] is '$'
					[method, _route] = actionMap[actionName] or ctrl.actionMap[actionName]
					route = _route "#{@_getResourceName ctrlName}s"
					@_logRoute method, route
					@router[method] route, _.bind(action, ctrl)

		# Bad Requests
		@router.use '*', (req, res) -> res.send error: 'Service not found', 404
	_logRoute: (method, route) ->
		logger.log 'route', logger.util.print("[#{method.toUpperCase()}]", 'green'), route

	# TODO: Is redundant
	_getResourceName: (ctrlName) -> ctrlName.toLowerCase().replace 'controller', ''


di.annotate V1, new di.Inject ComponentLoader
module.exports = V1
