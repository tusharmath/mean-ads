di = require 'di'
ModelFactory = require './ModelFactory'
CrudOperations = require './CrudOperations'
_ = require 'lodash'

class CrudOperationResolver
	constructor: (modFac) ->
		modFac.then (@models) =>

	getOperations: (resource) ->
		operations = injector.get CrudOperations
		operations.setup @models[resource]
		operations

	with: (resource) ->@getOperations resource

di.annotate CrudOperationResolver, new di.InjectPromise ModelFactory
module.exports = CrudOperationResolver
