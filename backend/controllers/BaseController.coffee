Q = require 'q'
{TransientScope, Inject} = require 'di'
_ = require 'lodash'
CrudsProvider = require '../providers/CrudsProvider'
errors = require '../config/error-codes'
class BaseController
	constructor: (crudsP) ->
		@Cruds = crudsP.cruds
		@_filterKeys = []
		@resourceName = null

		# TODO: Very Badly written, need a workaround
		get = =>
			if not @resourceName
				throw new Error 'resourceName has not been set!'
			if not @Cruds[@resourceName]
				throw new Error "Cruds.#{@resourceName} is not available!"
			@Cruds[@resourceName]

		Object.defineProperty @, 'crud', {get}

		# TODO: Need to write tests for this
		_.each ['list', 'update', 'create', 'remove', 'one', 'count'], (name) =>
			@["$#{name}"] = (req, res) =>
				@_endPromise res, @["_#{name}"] req, res
				.done()

	_endPromise: (res, promise) ->
		promise
		.then (doc) -> res.send doc
		.fail (err) => @_defaultErrorHandler res, err
		# .done()



	_defaultErrorHandler: (res, err) ->
		###
			No point sending a internal server errors here.
			It can directly be handled later
		###
		throw err if err.type isnt 'mean'
		res.status err.httpStatus
		res.send err

	_forbiddenDocument: (userId, doc) ->
		throw errors.FORBIDDEN_DOCUMENT if doc.owner isnt userId
		doc

	_notFoundDocument: (doc) ->
		throw errors.NOTFOUND_DOCUMENT if not doc
		doc

	_create: (req, res) ->
		req.body.owner = req.user.sub
		@crud.create req.body

	_update: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_notFoundDocument doc
			@_forbiddenDocument req.user.sub, doc
			@crud.update req.body, req.params.id

	_count: (req, res) ->
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud.count filter

	_list: (req, res) ->
		_populate = req.query.populate
		filter = _.pick req.query, @_filterKeys
		filter.owner = req.user.sub
		@crud.read _populate, filter

	_remove: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_notFoundDocument doc
			@_forbiddenDocument req.user.sub, doc
			@crud.delete req.params.id

	_one: (req, res) ->
		@crud.one req.params.id
		.then (doc) =>
			@_notFoundDocument doc
			@_forbiddenDocument req.user.sub, doc
			doc


BaseController.annotations = [
	new TransientScope()
	new Inject CrudsProvider
]
module.exports = BaseController
