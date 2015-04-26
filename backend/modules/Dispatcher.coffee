ModelFactory = require '../factories/ModelFactory'
DispatchPostDelivery = require './DispatchPostDelivery'
DispatchFactory = require '../factories/DispatchFactory'
DateProvder = require '../providers/DateProvider'
Q = require 'q'
_ = require 'lodash'
# {annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (
		@models
		@date
		@dispatchDelivery
		@dispatchFac
		) ->

	_getModel: (name) -> @models[name]
	_defaultOptions: (options) ->
		_options =
			keywords: []
			limit: 1
		_.assign _options, options
	getAllowedOrigins: (dispatchList) ->
			dispatch = _.find dispatchList, (d) -> d.allowedOrigins.length > 0
			return if dispatch then dispatch.allowedOrigins else []

	next: (programId, options) ->
		{keywords, limit} = @_defaultOptions options
		dispatchQuery = @_getModel 'Dispatch'
		.where program: programId
		.where startDate: $lte: @date.now()
		if keywords.length
			dispatchQuery = dispatchQuery.where('keywords').in keywords
		dispatchQuery.sort lastDeliveredOn: 'asc'
		.find()
		.limit limit
		.execQ()
		.then (dispatchList) =>
			_.each dispatchList, (d) =>
				@dispatchDelivery.delivered d, keywords
				.done()
			dispatchList

	subscriptionCreated: (subscriptionId) ->
		@dispatchFac.createForSubscriptionId subscriptionId

	subscriptionUpdated: (subscriptionId) ->
		@dispatchFac.updateForSubscriptionId subscriptionId

	_resourceUpdated: (resource, match, id) ->
		match = match.toLowerCase()
		filter = {}
		filter[match] = id
		@_getModel resource
		.where filter
		.find().execQ().then (items) =>
			Q.all _.map items, (i) => @["#{resource.toLowerCase()}Updated"] i._id

	campaignUpdated: (id) ->
		@_resourceUpdated 'Subscription', 'Campaign', id

	programUpdated: (id) ->
		@_resourceUpdated 'Campaign', 'Program', id

	styleUpdated: (id) ->
		@_resourceUpdated 'Program', 'Style', id

# annotate Dispatcher, new Inject(
# 	ModelFactory
# 	DateProvder
# 	DispatchPostDelivery
# 	DispatchFactory
# 	)
module.exports = Dispatcher
