di = require 'di'
q = require 'q'
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
di.annotate CrudOperations, new di.TransientScope()
module.exports = CrudOperations
