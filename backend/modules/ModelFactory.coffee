glob = require 'glob'
_ = require 'lodash'
{Inject} = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
ComponentLoader = require './ComponentLoader'

class ModelFactory
	constructor: (@db, @loader) ->

	init: ->
		models = {}
		@loader.load 'schema'
		.then (schemas) =>
			_.each schemas, (schema, modelName) =>
				bragi.log 'model', modelName
				models[modelName] = @db.conn.model(
					modelName
					schema @db.mongoose
				)
			models


ModelFactory.annotations = [
	new Inject DbConnection, ComponentLoader
]

module.exports = ModelFactory
