CrudFactory = require '../modules/CrudFactory'
Q = require 'q'
di = require 'di'
_ = require 'lodash'
class BaseController
	constructor: (@crudFac) ->
		@_filterKeys = []
	init: -> @crudFac.init().then (@cruds) =>

	_onError: (err) -> throw new Error err


	# [POST] /resource
	$create: (req, res) ->
		@cruds[@resource]
		.create req.body
		.done (resource) -> res.send resource


	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	$update: (req, res) ->
		@cruds[@resource]
		.update req.body, req.params.id
		.done (resource) -> res.send resource


	# [GET] /resource/$count
	$count: (req, res) ->
		@cruds[@resource]
		.count _.pick req.query, @_filterKeys
		.done (count) -> res.send {count}


	# [GET] /resource
	$list: (req, res) ->
		@cruds[@resource]
		.read @_populate, _.pick req.query, @_filterKeys
		.done (data) -> res.send data


	# [DELETE] /resource/:id
	$remove: (req, res) ->
		@cruds[@resource]
		.delete req.params.id
		.done -> res.send {deleted: req.params.id}


	# [GET] /resource/:id
	$first: (req, res) ->
		@crud
		.with @resource
		.one(req.params.id)
		.done (data) ->
			return res.send error: 'Document not found', 404 if not data
			res.send data

BaseController.annotations = [
	new di.Inject CrudFactory
]
module.exports = BaseController
