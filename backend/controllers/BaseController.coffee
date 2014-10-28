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

		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			if not @Cruds[@resourceName]
				throw new Error "Cruds.#{@resourceName} is not available!"
			@Cruds[@resourceName]

		Object.defineProperty @, 'crud', {get}

	_onError: (err) -> throw new Error err
	_defaultErrorHandler: (res) ->
		(err)->
			###
				No point sending a custom error here.
				It can directly be handled later
			###
			throw err if err.type isnt 'mean'

			bragi.log 'error', err
			res.status(err.httpStatus).send err


	# [POST] /resource
	$create: (req, res) ->
		@crud
		.create req.body
		.done(
			(resource) -> res.send resource
			@_defaultErrorHandler res
		 )


	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	$update: (req, res) ->
		@crud
		.one req.params.id
		.then (doc) =>
			if doc.owner isnt req.user.sub
				throw Error errors.FORBIDDEN_DOCUMENT
			else
				@crud.update req.body, req.params.id
		.done(
			(doc) ->res.send doc
			@_defaultErrorHandler res
		)


	# [GET] /resource/$count
	$count: (req, res) ->
		@crud
		.count _.pick(req.query, @_filterKeys)
		.done(
			(count) -> res.send {count}
			@_defaultErrorHandler res
		)


	# [GET] /resource
	$list: (req, res) ->
		filter = _.pick req.query, @_filterKeys
		@crud
		.read @_populate, filter
		.done(
			(data) -> res.send data
			@_defaultErrorHandler res
		)


	# [DELETE] /resource/:id
	$remove: (req, res) ->
		@crud
		.delete req.params.id
		.done(
			-> res.send {deleted: req.params.id}
			@_defaultErrorHandler res
		)


	# [GET] /resource/:id
	$one: (req, res) ->
		@crud
		.one req.params.id
		.done(
			(data) ->
				return res.send error: 'Document not found', 404 if not data
				res.send data
			@_defaultErrorHandler res
		)

BaseController.annotations = [
	new TransientScope()
	new Inject CrudsProvider
]
module.exports = BaseController
