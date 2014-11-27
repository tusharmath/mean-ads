{Inject, TransientScope} = require 'di'
ModelFactory = require '../factories/ModelFactory'
q = require 'q'
_ = require 'lodash'
class BaseCrud
	constructor: (modelFac) ->
		@resourceName = null

		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			if not modelFac.Models[@resourceName]
				throw new Error "Models.#{@resourceName} is not available!"

			modelFac.Models[@resourceName]

		Object.defineProperty @, 'model', {get}

	read: (populate = '', filter = {} ) ->
		@model
		.find filter
		.populate populate
		.execQ()

	one: (_id, populate = '') ->
		@model
		.findOne {_id}
		.populate populate
		.execQ()

	postUpdate: -> q.fcall ->
	update: (obj, id = obj._id) ->
		delete obj._id
		@model
		.findByIdAndUpdate id, obj
		.execQ()
		.then (obj) => @postUpdate obj

	preCreate: -> q.fcall ->
	create: (obj) ->
		resource = new @model obj
		@preCreate resource
		.then -> resource.saveQ()

	delete: (id) ->
		@model
		.findByIdAndRemove req.params.id
		.execQ()

	count: (filter) ->
		@model
		.count filter
		.execQ()

	_reduceQuery: (query, params) ->
		return query[params]() if typeof params is 'string'
		[qName] = _.keys params
		qArg = params[qName]
		query[qName] qArg

	query: (queries) ->
		_.reduce queries, @_reduceQuery, @model
		.execQ()

BaseCrud.annotations = [
	new TransientScope()
	new Inject ModelFactory
]

module.exports = BaseCrud
