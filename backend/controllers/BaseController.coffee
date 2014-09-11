ModelManager = require '../models'
di = require 'di'
_ = require 'lodash'

class BaseController
	constructor: (@modelManager) ->

	# [POST] /resource
	create: (req, res) ->
		resource = new @model req.body
		resource.save (err) ->
			return res.send err, 400 if err
			res.send resource

	# [PUT] /resource
	update: (req, res) ->
		resource = @model
		.findByIdAndUpdate req.params.id, req.body, (err) ->
			return res.send err, 400 if err
			res.send resource

	# [GET] /resource
	list: (req, res) ->
		@model
		.find {}
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
		@model.findById req.params.id, (err, data) ->
			return res.send err, 400 if err
			res.send data

BaseController.annotations = [
  new di.TransientScope()
  new di.Inject ModelManager
]
module.exports = BaseController
