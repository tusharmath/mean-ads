# Resolves routes to controllers and their actions
express = require 'express'
_ = require 'lodash'
config = require '../config/config'
newrelic = require 'newrelic'
Q = require 'q'
bragi = require 'bragi'
{ErrorPool, MeanError} = require '../config/error-codes'

class RouteResolver
	constructor: (ctrlFac) ->
		{@Controllers} = ctrlFac
	_resolveRoute: (ctrl, ctrlName, actionName) ->
		if not ctrl.actions
			throw new MeanError "actions have not been set for controller: #{ctrlName}"
		if not ctrl.actions.actionMap?[actionName]
			throw new MeanError "actionMap has not been set for action: #{ctrlName}: #{actionName}"
		[method, routeFunc] = ctrl.actions.actionMap[actionName]
		route = routeFunc ctrlName.toLowerCase()
		{method, route}
	_catch: (req, res, err) ->
		bragi.log 'error', err.stack
		if err.name is 'ValidationError'
			return res.status(400).send err
		switch err.type
			when 'mean'
				res.status(err.httpStatus).send err
			when 'ObjectId'
				err = ErrorPool.INVALID_OBJECT_ID
				res.status(err.httpStatus).send err
			when 'date'
				err = ErrorPool.INVALID_DATE
				res.status(err.httpStatus).send err
			else
				if config.newrelic.notify
					newrelic.noticeError err
				unknownErr = ErrorPool.UNKNOWN_ERROR
				res.status(unknownErr.httpStatus).send unknownErr
	_actionMiddleware: (ctrl, action, req, res) =>
		try
			action.call ctrl.actions, req, res
			.then (doc) -> res.send doc
			.catch (err) =>  @_catch req, res, err
			.done()
		catch err
			@_catch req, res, err

	_actionBinder: (router, ctrl, ctrlName, action, actionName) ->
		{method, route} = @_resolveRoute ctrl, ctrlName, actionName
		bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]"), route
		router[method] route, _.curry(@_actionMiddleware, 4) ctrl, action
	_forEveryAction: (router, controllers) ->
		_.each controllers, (ctrl, ctrlName) => _.forIn ctrl.actions, (action, actionName) =>
				return if not action or actionName[0] isnt '$'
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

# di.annotate RouteResolver, new di.Inject ControllerFactory
module.exports = RouteResolver
