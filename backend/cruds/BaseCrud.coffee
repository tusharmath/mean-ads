{Inject, TransientScope} = require 'di'
q = require 'q'
ModelFactory = require '../modules/ModelFactory'
class BaseCrud
	constructor: (@modelFac) ->

	# with: (userId) ->
	# 	_.reduce(
	# 		['read', 'update', 'one', 'find', 'create', 'delete']
	# 		(src, key) =>
	# 			src[key] = _.bind @[key], @, [userId]
	# 		{}
	# 	)

	init: =>
		@modelFac.then (@models) =>

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
	new Inject ModelFactory
]

module.exports = BaseCrud
