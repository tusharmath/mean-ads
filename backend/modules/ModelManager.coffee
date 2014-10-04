glob = require 'glob'
_ = require 'lodash'
di = require 'di'
DbConnection = require '../connections/DbConnection'

class ModelManager
	models : {}
	loadSchemaFiles: ->
		globOptions =
			cwd: './backend/schemas'
			sync: true #TODO: Make it unsync
		glob '*Schema.coffee', globOptions

	constructor: (@db) ->
		_.each @loadSchemaFiles(), @createModels, @

	createModels: (file) ->
		modelName = file.replace 'Schema.coffee', ''
		schemaCtor = require "../schemas/#{file}"
		schema = schemaCtor @db.mongoose
		@models[modelName] = @db.conn.model modelName, schema

di.annotate ModelManager, new di.Inject DbConnection
module.exports = ModelManager
