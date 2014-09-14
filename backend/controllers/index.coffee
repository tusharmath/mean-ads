glob = require 'glob'
_ = require 'lodash'
di = require 'di'

globOptions =
	cwd: './backend/controllers'
	sync: true

class ControllerManager
	constructor: ->
		@controllers = {}
		glob '*Controller.coffee', globOptions , (er, files) =>
			_.each files, (file) =>
				file = file.replace '\.coffee', ''
				@controllers[file] = injector.get require "./#{file}"
			# console.log 'Controllers Loaded', Object.keys @controllers
module.exports = ControllerManager
