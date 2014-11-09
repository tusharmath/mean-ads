Q = require 'q'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
CrudsProvider = require '../providers/CrudsProvider'
errors = require '../config/error-codes'
class BaseController
	constructor: (crudsP) ->
		@Cruds = crudsP.cruds
		@_filterKeys = []
		@resourceName = null

		# TODO: Very Badly written, need a workaround
		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			if not @Cruds[@resourceName]
				throw new Error "Cruds.#{@resourceName} is not available!"
			@Cruds[@resourceName]

		Object.defineProperty @, 'crud', {get}

	_forbiddenDocument: (userId, doc) ->
		throw errors.FORBIDDEN_DOCUMENT if doc.owner isnt userId
		doc

	$create: (req, res) ->
		req.body.owner = req.user.sub
		@crud.create req.body

	$update: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@crud.update req.body, req.params.id

	$count: (req, res) ->
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud.count filter
		.then (count)-> {count}

	$list: (req, res) ->
		_populate = req.query.populate
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud.read _populate, filter

	$remove: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			@crud.delete req.params.id

	$one: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_forbiddenDocument req.user.sub, doc
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject CrudsProvider
]
module.exports = BaseController
