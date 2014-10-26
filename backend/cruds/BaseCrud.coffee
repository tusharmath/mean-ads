{Inject, TransientScope} = require 'di'
ModelProvider = require '../providers/ModelProvider'
q = require 'q'
class BaseCrud
	constructor: (modelProvider) ->
		@Models = modelProvider.models
		@resourceName = null

		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			@Models[@resourceName]

		Object.defineProperty @, 'model', {get}

	read: (populate, filter = {}, owner ) ->
		filter.owner = owner
		@model
		.find filter
		.populate populate or ''
		.execQ()

	one: (_id, owner) ->
		@model
		.findOne {_id, owner}
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
	new Inject ModelProvider
]

module.exports = BaseCrud
