glob = require 'glob'
_ = require 'lodash'
{Inject} = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require '../modules/ComponentLoader'
ModelsProvider = require '../providers/ModelsProvider'
MongooseProvider = require '../providers/MongooseProvider'

class ModelFactory
	constructor: (@db, @loader, @modelsProvider, @mongooseP) ->
	create: (name, schema) ->
		@db.conn.model name, schema @mongooseP.mongoose
	init: ->
		models = {}
		@loader.load 'schema'
		.then (schemas) =>
			_.each schemas, (schema, modelName) =>
				bragi.log 'model', modelName
				models[modelName] = @create modelName, schema
			@modelsProvider.models = models


ModelFactory.annotations = [
	new Inject(
		DbConnection,
		ComponentLoader,
		ModelsProvider,
		MongooseProvider
	)
]

module.exports = ModelFactory
