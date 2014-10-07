di = require 'di'
ModelManager = require './ModelManager'
CrudOperations = require './CrudOperations'
_ = require 'lodash'

class CrudOperationResolver
	constructor: (modelManager) ->
		{@models} = modelManager
	getOperations: (resource) ->
		operations = injector.get CrudOperations

		operations.setup @models[resource]
		operations

	with: (resource) ->@getOperations resource

di.annotate CrudOperationResolver, new di.Inject ModelManager
module.exports = CrudOperationResolver
