express = require 'express'
config = require '../config/config'
_ = require 'lodash'
Controllers = require '../controllers'
di = require 'di'
{actionMap} = require './conventions'
class V1
	constructor: (ctrlManager) ->
		@router = express.Router()
		controllers = ctrlManager.controllers
		_.each controllers, (ctrl, ctrlName) =>
			_.forIn ctrl, (action, actionName) =>
				if actionName[0] is '$'
					[method, _route] = actionMap[actionName]
					resourceName = @_getResourceName ctrlName
					@router[method] _route("#{resourceName}s"), _.bind(action, ctrl)

		# Bad Requests
		@router.use '*', (req, res) -> res.send error: 'Service not found', 404

	_getResourceName: (ctrlName) -> ctrlName.toLowerCase().replace 'controller', ''


di.annotate V1, new di.Inject Controllers
module.exports = V1
