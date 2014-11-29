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

	crud: ->
		_crud = @modelFac.Models[@resourceName]
		return _crud if _crud
		throw new MeanError "#{@resourceName} was not found in #{_.keys @modelFac.Models}"

	_forbiddenDocument: (userId, doc) ->
		if doc.owner isnt userId
			throw ErrorPool.FORBIDDEN_DOCUMENT
		doc

	$create: (req, res) ->
		req.body.owner = req.user.sub
		@crud().create req.body

	$update: (req, res) ->
		@crud().one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@crud().update req.body, req.params.id

	$count: (req, res) ->
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud().count filter
		.then (count)-> {count}

	$list: (req, res) ->
		_populate = req.query.populate
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud().read _populate, filter

	$remove: (req, res) ->
		@crud().one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@crud().delete req.params.id

	$one: (req, res) ->
		@crud().one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject ModelFactory
]
module.exports = BaseController
