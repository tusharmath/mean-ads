Q = require 'q'
ModelFactory = require '../factories/ModelFactory'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
{ErrorPool, MeanError} = require '../config/error-codes'
class BaseController
	constructor: (@models) ->
		@_filterKeys = []
		@resourceName = null
		@hasListOwner = yes
		@hasOneOwner = yes
	actionMap:
		'$create': ['post', (str) -> "/core/#{str}"]
		'$list': ['get', (str) -> "/core/#{str}s"]
		'$count': ['get', (str) -> "/core/#{str}s/count"]
		'$one': ['get', (str) -> "/core/#{str}/:id"]
		'$update': ['patch', (str) -> "/core/#{str}/:id"]
		'$remove': ['delete', (str) -> "/core/#{str}/:id"]
	getModel: ->
		model = @models[@resourceName]
		return model if model
		throw new MeanError "#{@resourceName} was not found in Models"

	postCreateHook: (i) -> i
	$create: (req) ->
		req.body.owner = req.user.sub
		Model = @getModel()
		obj = new Model req.body
		obj.saveQ()
		.then (createResponse) => @postCreateHook createResponse
	postUpdateHook: (i) ->i
	$update: (req) ->
		@$one req
		.then =>
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
		if @hasListOwner
			filter.owner = req.user.sub
		@getModel().find filter
		.populate _populate
		.execQ()

	$remove: (req) ->
		@$one req
		.then =>
			@getModel().findByIdAndRemove req.params.id
			.execQ()

	$one: (req) ->
		@getModel().findOne _id: req.params.id
		.execQ()
		.then (doc) =>
			if doc is null then throw ErrorPool.NOTFOUND_DOCUMENT
			if @hasOneOwner && doc.owner isnt req.user.sub then throw ErrorPool.FORBIDDEN_DOCUMENT
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject ModelFactory
]
module.exports = BaseController
