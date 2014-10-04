BaseController = require './BaseController'

class StyleController
	constructor: () ->
		@model = @modelManager.models.Style
	StyleController:: = injector.get BaseController
module.exports = StyleController
