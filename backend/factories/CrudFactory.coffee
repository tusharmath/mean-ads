{Injector, Inject} = require 'di'
Q = require 'q'
_ = require 'lodash'
ComponentLoader = require './ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'
ModelFactory = require '../factories/ModelFactory'
ModelsProvider = require '../providers/ModelsProvider'

class CrudFactory
	constructor: (@loader, @injector, @modelFac, @modelPro) ->

	init: ->
		return Q.all [
			@loader.load 'crud', ['BaseCrud.coffee']
			@modelFac.init()
		]
		.spread @_onLoad

	_ctorReducer: (ref, ctor, ctorName) =>
		ctor :: = _.assign @injector.get(BaseCrud), ctor::
		crud = @injector.get ctor
		crud.resourceName = ctorName
		ref[ctorName] = crud
		bragi.log 'crud', ctorName
		ref

	_onLoad: (crudCtors, models) =>
		@modelPro.models = models
		_.reduce crudCtors, @_ctorReducer, {}

CrudFactory.annotations = [
	CrudFactory
	new Inject ComponentLoader, Injector, ModelFactory, ModelsProvider
]
module.exports = CrudFactory
