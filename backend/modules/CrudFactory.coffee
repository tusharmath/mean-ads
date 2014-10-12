di = require 'di'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'

class CrudFactory
	constructor: (loader, @injector) ->
		loader.load('crud', ['BaseCrud.coffee'])
		.done (@crudCtors) => @injector.get BaseCrud

	with: (resource) =>
		ctor = @crudCtors[resource]
		ctor :: = @injector.get BaseCrud
		crudOperator = @injector.get ctor
		crudOperator.model = crudOperator.models[resource]
		crudOperator

di.annotate(
	CrudFactory
	new di.Inject ComponentLoader, di.Injector
)
module.exports = CrudFactory
