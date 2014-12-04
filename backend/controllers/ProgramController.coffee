BaseController = require './BaseController'

class ProgramController

	constructor: () ->
		@_populate = path: 'style', select: 'name created placeholders'

	$update: (req) ->
		_updatedResponse = {}
		@_base.$update.call @, req
		.then (updatedResponse) =>
			_updatedResponse = updatedResponse
			@dispatch.programUpdated req.params.id
		.then -> _updatedResponse
module.exports = ProgramController
