express = require 'express'
config = require '../config/config'
_ = require 'lodash'
ControllerFactory = require '../modules/ControllerFactory'
di = require 'di'
Q = require 'q'
{actionMap} = require './conventions'

class V1
	constructor: (ctrlFac) ->
		router = express.Router()
		return ctrlFac
		.then (controllers) ->
			_.each controllers, (ctrl, ctrlName) ->
				_.forIn ctrl, (action, actionName) ->
					if actionName[0] is '$'
						[method, _route] = actionMap[actionName] or ctrl.actionMap[actionName]
						route = _route "#{ctrlName.toLowerCase()}s"
						router[method] route, _.bind(action, ctrl)
						bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]", 'green'), route
			router.use '*', (req, res) -> res.send error: 'Service not found', 404
			return Q.fcall -> router

di.annotate V1, new di.Inject ControllerFactory
module.exports = V1
