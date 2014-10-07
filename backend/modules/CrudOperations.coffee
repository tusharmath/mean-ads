di = require 'di'
class CrudOperations
	setup: (@model) ->
	read: (populate) ->
		@model
		.find {}
		.populate populate or ''
		.limit 10
		.exec()

	one: (id) ->
		@model
		.findById id
		.exec()

	update: (obj, id = obj._id) ->
		@model
		.findByIdAndUpdate id, obj
		exec()

	create: (obj) ->
		resource = new @model obj
		resource.save()

	delete: (id) ->
		@model
		.findByIdAndRemove req.params.id
		.exec()

	count: (filter) ->
		@model
		.count filter
		.exec()
di.annotate CrudOperations, new di.TransientScope()
module.exports = CrudOperations
