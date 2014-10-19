Q = require 'q'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
class BaseController
	constructor: ->
		@_filterKeys = []
	_onError: (err) -> throw new Error err


	# [POST] /resource
	$create: (req, res) ->
		@crud
		.create req.body
		.done (resource) -> res.send resource


	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	$update: (req, res) ->
		@crud
		.update req.body, req.params.id
		.done (resource) -> res.send resource


	# [GET] /resource/$count
	$count: (req, res) ->
		@crud
		.count _.pick req.query, @_filterKeys
		.done (count) -> res.send {count}


	# [GET] /resource
	$list: (req, res) ->
		@crud
		.read @_populate, _.pick req.query, @_filterKeys
		.done (data) -> res.send data


	# [DELETE] /resource/:id
	$remove: (req, res) ->
		@crud
		.delete req.params.id
		.done -> res.send {deleted: req.params.id}


	# [GET] /resource/:id
	$one: (req, res) ->
		@crud
		.one(req.params.id)
		.done (data) ->
			return res.send error: 'Document not found', 404 if not data
			res.send data

BaseController.annotations = [
	new TransientScope()
]
module.exports = BaseController
