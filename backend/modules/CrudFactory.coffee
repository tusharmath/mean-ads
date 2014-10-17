di = require 'di'
Q = require 'q'
_ = require 'lodash'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'

class CrudFactory
	constructor: (@loader, @injector) -> @_init()
	_init : ->
		Q.spread(
			@loader.load 'crud', ['BaseCrud.coffee']
			@injector.get BaseCrud
		).then @_onLoad
	_instantiate: (ref, ctor, ctorName) =>
		ctor:: = @baseCrud
		crud = @injector.get ctor
		ref[ctorName] = crud
		ref
	_onLoad: (crudCtors, @baseCrud) -> _.reduce crudCtors, @_instantiate, {}

di.annotate(
	CrudFactory
	new di.Inject ComponentLoader, di.Injector
)
module.exports = CrudFactory
