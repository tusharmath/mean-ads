di = require 'di'
Q = require 'q'
_ = require 'lodash'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'

class CrudFactory
	constructor: (@loader, @injector) ->

	init: ->
		@baseCrud = @injector.get BaseCrud
		return Q.all [
			@loader.load 'crud', ['BaseCrud.coffee']
			@baseCrud.init()
		]
		.spread @_onLoad

	_instantiate: (ref, ctor, ctorName) =>
		ctor:: = @baseCrud
		crud = @injector.get ctor
		crud.model = crud.models[ctorName]
		ref[ctorName] = crud
		bragi.log 'crud', ctorName
		ref

	_onLoad: (crudCtors) =>
		p = _.reduce(crudCtors, @_instantiate, {})

di.annotate(
	CrudFactory
	new di.Inject ComponentLoader, di.Injector
)
module.exports = CrudFactory
