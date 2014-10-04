BaseController = require './BaseController'

class ProgramController
	ProgramController:: = injector.get BaseController
	constructor: () ->
		@model = @modelManager.models.Program
		@_populate = path: 'style', select: 'name created placeholders'


module.exports = ProgramController
