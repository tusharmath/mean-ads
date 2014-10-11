di = require 'di'
q = require 'q'
ModelFactory = require '../modules/ModelFactory'
class BaseCrud
	constructor: (modelFac) ->
		modelFac.then (@models) =>

	read: (populate, filter = {} ) ->
		@model
		.find filter
		.populate populate or ''
		.execQ()

	one: (id) ->
		@model
		.findById id
		.execQ()

	find: (filter) ->
		@model
		.find filter
		.execQ()

	preUpdate: -> q.fcall ->
	update: (obj, id = obj._id) ->
		@model
		.findByIdAndUpdate id, obj
		.execQ()

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
di.annotate(
	BaseCrud
	new di.InjectPromise ModelFactory
	new di.TransientScope()
)
module.exports = BaseCrud
