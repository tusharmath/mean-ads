BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'

class StyleController
	constructor: (@actions, @dispatch) ->
		@actions.$create = null
		@actions.resourceName = 'Style'
		@actions.hasListOwner = no
		@actions.postUpdateHook = @postUpdateHook
	postUpdateHook: (style) =>
		@dispatch.styleUpdated style._id
		.then -> style

module.exports = StyleController
