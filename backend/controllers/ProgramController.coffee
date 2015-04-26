BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'

class ProgramController
	constructor: (@actions, @dispatch) ->
		@actions.resourceName = 'Program'
		@actions.postUpdateHook = @postUpdateHook
	postUpdateHook: (program) =>
		@dispatch.programUpdated program._id
		.then -> program

module.exports = ProgramController
