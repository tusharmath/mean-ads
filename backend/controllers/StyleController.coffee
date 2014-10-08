BaseController = require './BaseController'

class StyleController
	constructor: () ->
		@resource = 'Style'
	StyleController:: = injector.get BaseController
module.exports = StyleController
