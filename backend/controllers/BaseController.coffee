ModelManager = require '../modules/ModelManager'
CrudOperationResolver = require '../modules/CrudOperationResolver'
Q = require 'q'
di = require 'di'
_ = require 'lodash'

class BaseController
	constructor: (@crud) ->
		@_filterKeys = []
	createReqMutator: (reqBody) -> Q.fcall ->reqBody
	# [POST] /resource
	$create: (req, res) ->
		@crud
		.with @resource
		.create req.body
		.then(
			(data) -> res.send data
			(err) -> res.send err, 400 #TODO: Redundant needs to be put at one place
		)

	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	$update: (req, res) ->
		@crud
		.with @resource
		.update req.body, req.params.id
		.then(
			(resource) -> res.send resource
			(err) -> res.send err, 400 #TODO: Redundant needs to be put at one place
		)

	# [GET] /resource/$count
	$count: (req, res) ->
		@crud
		.with @resource
		.count _.pick req.query, @_filterKeys
		.then(
			(count) -> res.send {count}
			(err) -> res.send err, 400 #TODO: Redundant needs to be put at one place
		)

	# [GET] /resource
	$list: (req, res) ->
		@crud
		.with @resource
		.read @_populate, req.query
		.then(
			(data) -> res.send data
			(err) -> res.send err, 400 #TODO: Redundant needs to be put at one place
		)

	# [DELETE] /resource/:id
	$remove: (req, res) ->
		@crud
		.with @resource
		.delete req.params.id
		.then(
			-> res.send {deleted: req.params.id}
			-> res.send error: 'Document not found', 404
		)

	# [GET] /resource/:id
	$first: (req, res) ->
		@crud
		.with @resource
		.one(req.params.id)
		.then(
			(data) ->
				return res.send error: 'Document not found', 404 if not data
				res.send data
			(err) -> res.send err, 400 #TODO: Redundant needs to be put at one place
		)

BaseController.annotations = [
	new di.TransientScope()
	new di.Inject CrudOperationResolver
]
module.exports = BaseController
