ModelFactory = require '../factories/ModelFactory'
DispatchPostDelivery = require './DispatchPostDelivery'
DispatchFactory = require '../factories/DispatchFactory'
DateProvder = require '../providers/DateProvider'
Q = require 'q'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (
		@modelFac
		@date
		@dispatchDelivery
		@dispatchFac
		) ->

	_getModel: (name) -> @modelFac.models()[name]
	next: (programId, keywords = [], count = 1) ->
		q = @_getModel 'Dispatch'
		.where program: programId
		.where startDate: $lte: @date.now()

		if keywords.length
			q = q
			.where 'keywords'
			.in keywords
		q.sort lastDeliveredOn: 'asc'
		.find()
		.limit count
		.execQ()
		.then (dispatch) =>
			if dispatch
				@dispatchDelivery.delivered dispatch
				.done()
				return dispatch
			null

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

annotate Dispatcher, new Inject(
	ModelFactory
	DateProvder
	DispatchPostDelivery
	DispatchFactory
	)
module.exports = Dispatcher
