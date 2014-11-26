glob = require 'glob'
_ = require 'lodash'
{Inject} = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require '../modules/ComponentLoader'
MongooseProvider = require '../providers/MongooseProvider'

class ModelFactory
	constructor: (@db, @loader, @mongooseP) ->
		@init()

	create: (name, schema) ->
		@db.conn.model name, schema @mongooseP.mongoose
	init: ->
		@loader.load 'schema'
		.then (schemas) =>
			_.each schemas, (schema, modelName) =>
				bragi.log 'model', modelName
				@Models[modelName] = @create modelName, schema
	Models: {}

ModelFactory.annotations = [
	new Inject(
		DbConnection,
		ComponentLoader,
		MongooseProvider
	)
]

module.exports = ModelFactory
