glob = require 'glob'
_ = require 'lodash'
{Inject} = require 'di'
Q = require 'q'
DbConnection = require '../connections/DbConnection'
MongoModelProvider require  '../providers/MongoModelProvider'
ComponentLoader = require './ComponentLoader'

class ModelFactory
	constructor: (@mongoModel, @loader) ->

	init: ->
		models = {}
		@loader.load 'schema'
		.then (schemas) =>_.each schemas, (schema, modelName) =>
			bragi.log 'model', modelName
			models[modelName] = @mongoModel.create(
				modelName
				schema
			)
			models


ModelFactory.annotations = [
	new Inject DbConnection, ComponentLoader
]

module.exports = ModelFactory
