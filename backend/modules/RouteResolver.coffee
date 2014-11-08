# Resolves routes to controllers and their actions
express = require 'express'
_ = require 'lodash'
ControllerFactory = require '../factories/ControllerFactory'
di = require 'di'
Q = require 'q'
errors = require '../config/error-codes'

defaultActionMap =
	'$create': ['post', (str) -> "/core/#{str}"]
	'$list': ['get', (str) -> "/core/#{str}s"]
	'$count': ['get', (str) -> "/core/#{str}s/count"]
	'$one': ['get', (str) -> "/core/#{str}/:id"]
	'$update': ['patch', (str) -> "/core/#{str}/:id"]
	'$remove': ['delete', (str) -> "/core/#{str}/:id"]

class V1
	constructor: (@ctrlFac) ->

	init: ->

		@ctrlFac.init()
		.then @_onLoad
	_onLoad: (controllers) ->
		router = express.Router()
		_.each controllers, (ctrl, ctrlName) -> _.forIn ctrl, (action, actionName) ->
			return if actionName[0] isnt '$'
			[method, _route] = defaultActionMap[actionName] or ctrl.actionMap[actionName]
			route = _route ctrlName.toLowerCase()
			bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]", 'green'), route
			router[method] route, _.bind action, ctrl
		router.use '*', (req, res) ->
			err404 = errors.NOTFOUND_RESOURCE
			res
			.status err404.httpStatus
			.send err404.message
		return Q router

di.annotate V1, new di.Inject ControllerFactory
module.exports = V1
