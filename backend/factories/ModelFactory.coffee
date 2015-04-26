{MeanError} = require '../config/error-codes'
_ = require 'lodash'
bragi = require 'bragi'
Q = require 'q'

# TODO: Dynamically Set
ModelNames = [
	'Campaign'
	'Dispatch'
	'Program'
	'Style'
	'Subscription'
]

class ModelFactory
	constructor: (@db, @mongooseP, @requireProvider) ->

	_reduce: (models, resourceName) =>
		throw new MeanError 'resourceName is required' if not resourceName
		schema = @requireProvider.require "../schemas/#{resourceName}Schema"
		bragi.log 'resource', resourceName
		models[resourceName] = @db.conn.model resourceName, schema @mongooseP.mongoose
		models

	create: -> _.reduce ModelNames, @_reduce, @

module.exports = ModelFactory
