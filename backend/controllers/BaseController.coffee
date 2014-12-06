Q = require 'q'
ModelFactory = require '../factories/ModelFactory'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
{ErrorPool, MeanError} = require '../config/error-codes'
class BaseController
	constructor: (@modelFac) ->
		@_filterKeys = []
		@resourceName = null

	getModel: ->
		model = @modelFac.Models[@resourceName]
		return model if model
		throw new MeanError "#{@resourceName} was not found in #{_.keys @modelFac.Models}"
	override: (key, client) ->
		override = client[key]
		_temp = @[key]
		@[key] = (args...) =>
			args.unshift _temp
			override.apply @, args

	_forbiddenDocument: (userId, doc) ->
		if doc.owner isnt userId
			throw ErrorPool.FORBIDDEN_DOCUMENT
		doc

	$create: (req) ->
		req.body.owner = req.user.sub
		Model = @getModel()
		obj = new Model req.body
		obj.saveQ()
	postUpdateHook: (i) ->i
	$update: (req) ->
		@getModel()
		.findOne _id: req.params.id
		.execQ()
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			delete req.body._id
			@getModel()
			.findByIdAndUpdate req.params.id, req.body
			.execQ()
		.then (updatedData) =>
			@postUpdateHook updatedData

	$count: (req) ->
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@getModel().count filter
		.execQ()
		.then (count)-> {count}

	$list: (req) ->
		_populate = req.query?.populate or ''
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@getModel().find filter
		.populate _populate
		.execQ()

	$remove: (req) ->
		@getModel()
		.findOne _id: req.params.id
		.execQ()
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@getModel().findByIdAndRemove req.params.id
			.execQ()

	$one: (req) ->
		@getModel().findOne _id: req.params.id
		.execQ()
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject ModelFactory
]
module.exports = BaseController
