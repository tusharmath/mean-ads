BaseController = require './BaseController'

class ProgramController

	constructor: () ->
		@_populate = path: 'style', select: 'name created placeholders'


module.exports = ProgramController
