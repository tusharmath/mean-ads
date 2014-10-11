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
		.limit 10
		.exec()

	one: (id) ->
		@model
		.findById id
		.exec()

	find: (filter) ->
		@model
		.find filter
		.exec()

	update: (obj, id = obj._id) ->
		@model
		.findByIdAndUpdate id, obj
		.exec()

	create: (obj) ->
		defer = q. defer()
		resource = new @model obj
		resource
		.save (err, res) ->
			defer.reject err if err
			defer.resolve res
		defer.promise

	delete: (id) ->
		@model
		.findByIdAndRemove req.params.id
		.exec()

	count: (filter) ->
		@model
		.count filter
		.exec()
di.annotate(
	BaseCrud
	new di.InjectPromise ModelFactory
	new di.TransientScope()
)
module.exports = BaseCrud
