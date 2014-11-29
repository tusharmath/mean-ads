Q = require 'q'
ModelFactory = require '../factories/ModelFactory'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
CrudsProvider = require '../providers/CrudsProvider'
{ErrorPool, MeanError} = require '../config/error-codes'
class BaseController
	constructor: (@modelFac) ->
		@_filterKeys = []
		@resourceName = null

	getModel: ->
		model = @modelFac.Models[@resourceName]
		return model if model
		throw new MeanError "#{@resourceName} was not found in #{_.keys @modelFac.Models}"

	_forbiddenDocument: (userId, doc) ->
		if doc.owner isnt userId
			throw ErrorPool.FORBIDDEN_DOCUMENT
		doc

	$create: (req) ->
		req.body.owner = req.user.sub
		Model = @getModel()
		obj = new Model req.body
		obj.saveQ()

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
		@getModel().one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@getModel().delete req.params.id

	$one: (req) ->
		@getModel().one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject ModelFactory
]
module.exports = BaseController
