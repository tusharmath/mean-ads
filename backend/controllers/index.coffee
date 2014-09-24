glob = require 'glob'
_ = require 'lodash'
di = require 'di'

globOptions =
	cwd: './backend/controllers'
	sync: false

class ControllerManager
	constructor: ->
		@controllers = {}
		glob '*Controller.coffee', globOptions , (er, files) =>
			_.each files, (file) =>
				file = file.replace '\.coffee', ''
				@controllers[file] = injector.get require "./#{file}"
module.exports = ControllerManager
