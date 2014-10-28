{Injector, Inject} = require 'di'
Q = require 'q'
_ = require 'lodash'
ComponentLoader = require '../modules/ComponentLoader'
BaseCrud = require '../cruds/BaseCrud'
ModelFactory = require '../factories/ModelFactory'
CrudsProvider = require '../providers/CrudsProvider'

class CrudFactory
	constructor: (@loader, @injector, @modelF, @crudsP) ->

	init: ->
		return Q.all [
			@loader.load 'crud', ['BaseCrud.coffee']
			@modelF.init()
		]
		.spread @_onLoad

	_ctorReducer: (ref, ctor, ctorName) =>
		baseCrud = @injector.get BaseCrud
		baseCrud.resourceName = ctorName
		[_proto, ctor::] = [ctor::, baseCrud]

		_.assign ctor::, _proto
		crud = @injector.get ctor
		# crud.resourceName = ctorName
		ref[ctorName] = crud
		bragi.log 'crud', ctorName
		ref

	_onLoad: (crudCtors) =>
		@crudsP.cruds = _.reduce crudCtors, @_ctorReducer, {}

CrudFactory.annotations = [
	CrudFactory
	new Inject ComponentLoader, Injector, ModelFactory, CrudsProvider
]
module.exports = CrudFactory
