Q = require 'q'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
errors = require '../config/error-codes'
class BaseController
	constructor: ->
		@_filterKeys = []
	_onError: (err) -> throw new Error err
	_defaultErrorHandler: (res) ->
		(err)->
			bragi.log 'error', err
			if err.type isnt 'mean'
				err = errors.INTERNAL_SERVER_ERROR
			res.status(err.httpStatus).send err


	# [POST] /resource
	$create: (req, res) ->
		@crud
		.create req.body, req.user.sub
		.done(
			(resource) -> res.send resource
			@_defaultErrorHandler res
		 )


	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	$update: (req, res) ->
		@crud
		.update req.body, req.params.id, req.user.sub
		.done(
			(resource) -> res.send resource
			@_defaultErrorHandler res
		)


	# [GET] /resource/$count
	$count: (req, res) ->
		@crud
		.count _.pick(req.query, @_filterKeys), req.user.sub
		.done(
			(count) -> res.send {count}
			@_defaultErrorHandler res
		)


	# [GET] /resource
	$list: (req, res) ->
		@crud
		.read @_populate, _.pick(req.query, @_filterKeys), req.user.sub
		.done(
			(data) -> res.send data
			@_defaultErrorHandler res
		)


	# [DELETE] /resource/:id
	$remove: (req, res) ->
		@crud
		.delete req.params.id, req.user.sub
		.done(
			-> res.send {deleted: req.params.id}
			@_defaultErrorHandler res
		)


	# [GET] /resource/:id
	$one: (req, res) ->
		@crud
		.one req.params.id, req.user.sub
		.done(
			(data) ->
				return res.send error: 'Document not found', 404 if not data
				res.send data
			@_defaultErrorHandler res
		)

BaseController.annotations = [
	new TransientScope()
]
module.exports = BaseController
