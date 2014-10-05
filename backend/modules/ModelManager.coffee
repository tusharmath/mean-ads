glob = require 'glob'
_ = require 'lodash'
di = require 'di'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require './ComponentLoader'

class ModelManager
	constructor: (@db, @loader) ->
		@models = {}
		schemas = @loader.load 'schema'
		_.each schemas, (schema, modelName) =>
			@models[modelName] = @db.conn.model modelName, schema @db.mongoose

di.annotate ModelManager, new di.Inject DbConnection, ComponentLoader
module.exports = ModelManager
