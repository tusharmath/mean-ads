ModelManager = require '../models'
Q = require 'q'
di = require 'di'
_ = require 'lodash'

class BaseController
	constructor: (@modelManager) ->

	createReqMutator: (reqBody) -> Q.fcall ->reqBody
	# [POST] /resource
	create: (req, res) ->
		@createReqMutator req.body
		.then (reqBody) =>
			resource = new @model req.body
			resource.save (err) ->
				if err
					return res
					.status 400
					.send err

				res.send resource

	# TODO: Use a patch mutator to ignore/add keys
	# [PATCH] /resource
	update: (req, res) ->
		resource = @model
		.findByIdAndUpdate req.params.id, req.body, (err) ->
			return res.send err, 400 if err
			res.send resource

	# [GET] /resource
	list: (req, res) ->
		@model
		.find {}
		.populate @_populate || ''
		.limit 10
		.exec (err, data) ->
			return res.send err, 400 if err
			res.send data

	# [DELETE] /resource/:id
	remove: (req, res) ->
		@model
		.findByIdAndRemove req.params.id, -> res.send 'DELETED'

	# [GET] /resource/:id
	first: (req, res) ->
		@model
		.findById req.params.id
		.exec (err, data) ->
			return res.status(400).send err if err
			res.send data

BaseController.annotations = [
	new di.TransientScope()
	new di.Inject ModelManager
]
module.exports = BaseController
