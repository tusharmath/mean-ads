{Inject, TransientScope} = require 'di'
ModelsProvider = require '../providers/ModelsProvider'
q = require 'q'
class BaseCrud
	constructor: (modelsProvider) ->
		@Models = modelsProvider.models
		@resourceName = null

		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			@Models[@resourceName]

		Object.defineProperty @, 'model', {get}

	read: (populate, filter = {} ) ->
		@model
		.find filter
		.populate populate or ''
		.execQ()

	one: (_id) ->
		@model
		.findOne {_id}
		.execQ()

	postUpdate: -> q.fcall ->
	update: (obj, id = obj._id) ->
		@model
		.findByIdAndUpdate id, obj
		.execQ()
		.then @postUpdate obj

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

BaseCrud.annotations = [
	new TransientScope()
	new Inject ModelsProvider
]

module.exports = BaseCrud
