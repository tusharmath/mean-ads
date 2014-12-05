{Inject, annotate} = require 'di'
BaseController = require './BaseController'
class ProgramController
	constructor: (@actions) ->
		@actions.resourceName = 'Program'
	$update: (req) ->
		_updatedResponse = {}
		@_base.$update.call @, req
		.then (updatedResponse) =>
			_updatedResponse = updatedResponse
			@dispatch.programUpdated req.params.id
		.then -> _updatedResponse
annotate ProgramController, new Inject BaseController
module.exports = ProgramController
