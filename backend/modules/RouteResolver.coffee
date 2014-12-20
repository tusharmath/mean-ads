# Resolves routes to controllers and their actions
express = require 'express'
_ = require 'lodash'
config = require '../config/config'
bugsnag = require 'bugsnag'
ControllerFactory = require '../factories/ControllerFactory'
di = require 'di'
Q = require 'q'
{ErrorPool, MeanError} = require '../config/error-codes'

class V1
	constructor: (ctrlFac) ->
		{@Controllers} = ctrlFac
	_resolveRoute: (ctrl, ctrlName, actionName) ->
		if not ctrl.actions
			throw new MeanError "actions have not been set for controller: #{ctrlName}"
		if not ctrl.actions.actionMap?[actionName]
			throw new MeanError "actionMap has not been set for action: #{actionName}"
		[method, routeFunc] = ctrl.actions.actionMap[actionName]
		route = routeFunc ctrlName.toLowerCase()
		{method, route}
	_actionMiddleware: (ctrl, action, req, res) ->

		action.call ctrl.actions, req, res
		.then (doc) -> res.send doc
		.fail (err) ->
			switch err.type
				when 'mean'
					res.status(err.httpStatus).send err
				when 'ObjectId'
					err = ErrorPool.NOTFOUND_DOCUMENT
					res.status(err.httpStatus).send err
				else
					if config.bugsnag.notify
						bugsnag.notify err, {req}
						unknownErr = ErrorPool.UNKNOWN_ERROR
						res.status(unknownErr.httpStatus).send unknownErr
					else
						throw err
		.done()
	_actionBinder: (router, ctrl, ctrlName, action, actionName) ->
		{method, route} = @_resolveRoute ctrl, ctrlName, actionName
		bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]"), route
		router[method] route, _.curry(@_actionMiddleware, 4) ctrl, action
	_forEveryAction: (router, controllers) ->
		_.each controllers, (ctrl, ctrlName) =>
			_.forIn ctrl.actions, (action, actionName) =>
				return if actionName[0] isnt '$'
				@_actionBinder router, ctrl, ctrlName, action, actionName
	_otherRoutes: (router) ->
		router.use '*', (req, res) ->
			err404 = ErrorPool.NOTFOUND_RESOURCE
			res.status err404.httpStatus
			.send err404.message
	router: () =>
		router = new express.Router()
		@_forEveryAction router, @Controllers
		@_otherRoutes router
		router

di.annotate V1, new di.Inject ControllerFactory
module.exports = V1
