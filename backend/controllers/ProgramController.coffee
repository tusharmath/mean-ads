BaseController = require './BaseController'

class ProgramController
	ProgramController:: = injector.get BaseController
	constructor: () ->
		@resource = 'Program'
		@_populate = path: 'style', select: 'name created placeholders'


module.exports = ProgramController
