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

	_getActionMap: (ctrl, actionName) ->
		defaultActionMap[actionName] or ctrl.actionMap[actionName]

	_actionMiddleware: (ctrl, action, req, res) ->
		action.call ctrl, req, res
		.then (doc) -> res.send doc
		.fail (err) ->
			switch err.type
				when 'mean'
					res.status(err.httpStatus).send err
				when 'ObjectId'
					err = errors.NOTFOUND_DOCUMENT
					res.status(err.httpStatus).send err
				else
					throw err
		.done()

	_actionBinder: (router, ctrl, ctrlName, action, actionName) ->
		return if actionName[0] isnt '$'
		[method, routeFunc] = @_getActionMap ctrl, actionName
		route = routeFunc ctrlName.toLowerCase()
		bragi.log 'api', bragi.util.print("[#{method.toUpperCase()}]", 'green'), route
		router[method] route, _.curry(@_actionMiddleware, 4) ctrl, action

	_forEveryAction: (router, controllers) ->
		_.each controllers, (ctrl, ctrlName) =>
			_.forIn ctrl, (action, actionName) =>
				@_actionBinder router, ctrl, ctrlName, action, actionName

	_otherRoutes: (router) ->
		router.use '*', (req, res) ->
			err404 = errors.NOTFOUND_RESOURCE
			res.status err404.httpStatus
			.send err404.message

	_onLoad: (controllers) =>
		router = express.Router()
		@_forEveryAction router, controllers
		@_otherRoutes router
		router

di.annotate V1, new di.Inject ControllerFactory
module.exports = V1
