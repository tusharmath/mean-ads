glob = require 'glob'
_ = require 'lodash'
di = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require './ComponentLoader'

class ModelManager
	constructor: (db, loader) ->
		models = {}
		return loader
		.load 'schema'
		.then (schemas) ->
			_.each schemas, (schema, modelName) ->
				models[modelName] = db.conn.model modelName, schema db.mongoose
				bragi.log 'model', modelName
			return Q.fcall -> models


di.annotate ModelManager, new di.Inject DbConnection, ComponentLoader
module.exports = ModelManager
