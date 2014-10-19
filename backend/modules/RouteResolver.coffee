express = require 'express'
_ = require 'lodash'
ControllerFactory = require '../modules/ControllerFactory'
di = require 'di'
Q = require 'q'

defaultActionMap =
	'$create': ['post', (str) -> "/#{str}"]
	'$list': ['get', (str) -> "/#{str}"]
	'$count': ['get', (str) -> "/#{str}/count"]
	'$one': ['get', (str) -> "/#{str}/:id"]
	'$update': ['patch', (str) -> "/#{str}/:id"]
	'$remove': ['delete', (str) -> "/#{str}/:id"]

class V1
	constructor: (@ctrlFac) ->

	init: ->

		@ctrlFac.init()
		.then @_onLoad
	_onLoad: (controllers) ->
		router = express.Router()
		_.each controllers, (ctrl, ctrlName) ->
			_.forIn ctrl, (action, actionName) ->
				if actionName[0] is '$'
					[method, _route] = defaultActionMap[actionName] or ctrl.actionMap[actionName]
					route = _route "#{ctrlName.toLowerCase()}s"
					bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]", 'green'), route
					router[method] route, _.bind action, ctrl
		router.use '*', (req, res) -> res.send error: 'Service not found', 404
		return Q.fcall -> router

di.annotate V1, new di.Inject ControllerFactory
module.exports = V1
