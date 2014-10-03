glob = require 'glob'
_ = require 'lodash'
di = require 'di'

globOptions =
	cwd: './backend/controllers'
	# TODO: Need to convert ot async for better performance
	sync: true

class ControllerManager
	constructor: ->
		@controllers = {}
		glob '*Controller.coffee', globOptions , (er, files) =>
			_.each files, (file) =>
				file = file.replace '\.coffee', ''
				if file isnt 'BaseController'
					@controllers[file] = injector.get require "./#{file}"
module.exports = ControllerManager
