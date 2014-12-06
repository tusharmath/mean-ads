{Inject, annotate} = require 'di'
BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'

class StyleController
	constructor: (@actions, @dispatch) ->
		@actions.resourceName = 'Style'
		@actions.postUpdateHook = @postUpdateHook
	postUpdateHook: (style) ->
		@dispatch.styleUpdated style._id
		.then -> style
annotate StyleController, new Inject BaseController, Dispatcher
module.exports = StyleController
