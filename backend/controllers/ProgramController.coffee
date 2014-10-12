BaseController = require './BaseController'

class ProgramController

	constructor: () ->
		@resource = 'Program'
		@_populate = path: 'style', select: 'name created placeholders'


module.exports = ProgramController
