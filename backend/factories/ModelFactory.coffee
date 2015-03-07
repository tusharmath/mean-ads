{MeanError} = require '../config/error-codes'
DbConnection = require '../connections/DbConnection'
MongooseProvider = require '../providers/MongooseProvider'
RequireProvider = require '../providers/RequireProvider'
{Inject} = require 'di'
glob = require 'glob'
_ = require 'lodash'
Q = require 'q'

# TODO: Dynamically Set, Via Gulp
ModelNames = [
	'Campaign'
	'Dispatch'
	'Program'
	'Style'
	'Subscription'
	'SubscriptionActivity'
	'Visitor'
]

class ModelFactory
	constructor: (@db, @mongooseP, @requireProvider) ->
	create: (models, resourceName) =>
		throw new MeanError 'resourceName is required' if not resourceName
		schema = @requireProvider.require "../schemas/#{resourceName}Schema"
		bragi.log 'resource', resourceName
		models[resourceName] = @db.conn.model resourceName, schema @mongooseP.mongoose
		models

	models: ->
		return @Models if @Models
		@Models = _.reduce ModelNames, @create, {}

ModelFactory.annotations = [
	new Inject(
		DbConnection,
		MongooseProvider,
		RequireProvider
	)
]

module.exports = ModelFactory
