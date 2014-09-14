BaseController = require './BaseController'

class ProgramController
	constructor: () ->
		@model = @modelManager.models.ProgramModel
		@_populate = path: 'style', select: 'name'
	ProgramController:: = injector.get BaseController

	# [GET] /resource/:id
	first: (req, res) ->
		@model
			.findById req.params.id
			.populate path: "style", select: 'name created placeholders'
			.exec (err, data) ->
				return res.send err, 400 if err
				res.send data

module.exports = ProgramController
