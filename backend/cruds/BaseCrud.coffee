{Inject, TransientScope} = require 'di'
q = require 'q'
class BaseCrud
	read: (populate, filter = {} ) ->
		@model
		.find filter
		.populate populate or ''
		.execQ()

	one: (id) ->
		@model
		.findById id
		.execQ()

	postUpdate: -> q.fcall ->
	update: (obj, id = obj._id) ->
		@model
		.findByIdAndUpdate id, obj
		.execQ()
		.then @postUpdate obj

	preCreate: -> q.fcall ->
	create: (obj, user) ->
		obj.owner = user
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

BaseCrud.annotations = [
	new TransientScope()
]

module.exports = BaseCrud
