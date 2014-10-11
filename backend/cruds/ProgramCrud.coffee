BaseCrud = require './BaseCrud'

class ProgramCrud
	constructor: () ->
	ProgramCrud:: = injector.get BaseCrud

module.exports = ProgramCrud
