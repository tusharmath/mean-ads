{Injector, Inject} = require 'di'
Q = require 'q'
_ = require 'lodash'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'
ModelFactory = require '../modules/ModelFactory'

class CrudFactory
	constructor: (@loader, @injector, @modelFac) ->

	init: ->
		return Q.all [
			@loader.load 'crud', ['BaseCrud.coffee']
			@modelFac.init()
		]
		.spread @_onLoad

	_ctorReducer: (ref, ctor, ctorName) =>
		ctor :: = _.assign @injector.get(BaseCrud), ctor::
		crud = @injector.get ctor
		crud.models = @models
		# crud.model = crud.models[ctorName]
		ref[ctorName] = crud
		bragi.log 'crud', ctorName
		ref

	_onLoad: (crudCtors, @models) =>
		_.reduce crudCtors, @_ctorReducer, {}

CrudFactory.annotations = [
	CrudFactory
	new Inject ComponentLoader, Injector, ModelFactory
]
module.exports = CrudFactory
