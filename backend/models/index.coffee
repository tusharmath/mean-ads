glob = require 'glob'
_ = require 'lodash'
di = require 'di'
mongoose = require 'mongoose'
DbConnection = require '../connections/DbConnection'

globOptions =
	cwd: './backend/models'
	sync: true

class ModelManager
	models : {}
	constructor: (@db) ->
		glob '*Model.coffee', globOptions , (er, files) =>
			# TODO: Move it out
			_.each files, @load, @
	load: (file) ->
		file = file.replace '\.coffee', ''
		@models[file] = require("./#{file}") (mongoose)

di.annotate ModelManager, new di.Inject DbConnection
module.exports = ModelManager
