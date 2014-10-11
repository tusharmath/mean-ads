di = require 'di'
ComponentLoader = require './ComponentLoader'
_ = require 'lodash'

class CrudFactory
	constructor: (loader) ->
		loader.load('crud', ['BaseCrud.coffee']).then (@crudCtors) =>

	with: (resource) ->
		crudOperator = injector.get @crudCtors[resource]
		crudOperator.model = crudOperator.models[resource]
		crudOperator

di.annotate(
	CrudFactory
	new di.Inject ComponentLoader
)
module.exports = CrudFactory
