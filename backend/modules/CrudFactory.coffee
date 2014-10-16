di = require 'di'
_ = require 'lodash'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'

class CrudFactory
	constructor: (@loader, @injector) -> @_init()
	_init : ->
		@loader.load 'crud', ['BaseCrud.coffee']
		.then @_onLoad
	_instantiate: (ref, ctor, ctorName) =>
		ctor:: = @injector.get BaseCrud
		ref[ctorName] = @injector.get ctor
		ref
	_onLoad: (crudCtors) -> _.reduce crudCtors, @_instantiate, {}

di.annotate(
	CrudFactory
	new di.Inject ComponentLoader, di.Injector
)
module.exports = CrudFactory
