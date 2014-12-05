{Inject, annotate} = require 'di'
BaseController = require './BaseController'

class StyleController
	constructor: (@actions) ->
		@actions.resourceName = 'Style'
annotate StyleController, new Inject BaseController
module.exports = StyleController
