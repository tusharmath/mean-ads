glob = require 'glob'
_ = require 'lodash'
{Inject} = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require '../modules/ComponentLoader'
ModelsProvider = require '../providers/ModelsProvider'

class ModelFactory
	constructor: (@db, @loader, @modelsProvider) ->
	create: (name, schema) ->
		@db.mongoose.model name, schema @db.mongoose
	init: ->
		models = {}
		@loader.load 'schema'
		.then (schemas) =>
			_.each schemas, (schema, modelName) =>
				bragi.log 'model', modelName
				models[modelName] = @create modelName, schema
			@modelsProvider.models = models


ModelFactory.annotations = [
	new Inject DbConnection, ComponentLoader, ModelsProvider
]

module.exports = ModelFactory
