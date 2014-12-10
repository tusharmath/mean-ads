ModelFactory = require '../factories/ModelFactory'
Q = require 'q'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @css) ->

	_getModel: (name) -> @modelFac.models()[name]
	_increaseUsedCredits: (subscription) ->
		@_getModel 'Subscription'
		.findByIdAndUpdate subscription._id, usedCredits: subscription.usedCredits + 1
		.execQ()
	_populateSubscription: (subscriptionId) ->
		_subscription = {}
		@_getModel 'Subscription'
		.findOne _id: subscriptionId
		.populate 'campaign'
		.execQ()
		.then (subscription) ->
			_subscription = subscription
			subscription.campaign.populateQ 'program'
		.then (campaign) ->
			_subscription.campaign = campaign
			campaign.program.populateQ 'style'
		.then (program) ->
			# console.log _subscription
			_subscription.campaign.program = program
			_subscription
	_interpolateMarkup: (subscription) ->
		{_id, html, css} = subscription.campaign.program.style
		_wrappedHtml = "<div id=\"style-#{_id}\">#{html}</div>"
		_wrappedHtml = @dot.template(_wrappedHtml) subscription.data
		_wrappedHtml = "<style>#{@css.minify css}</style>#{_wrappedHtml}" if css
		_wrappedHtml
	_createDispatchable: (subscription) ->
		Dispatch = @_getModel 'Dispatch'
		@_interpolateMarkup subscription
		.then (markup) ->
		new Dispatch(
				markup: markup
			subscription: subscription._id
			program: subscription.campaign.program._id
			keywords: subscription.campaign.keywords
			)
		.saveQ()
	_removeDispatchable: (subscriptionId) ->
		@_getModel 'Dispatch'
		.find subscription: subscriptionId
		.remove()
		.execQ()
	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn: Date.now()
		.execQ()
	_postDispatch: (dispatch) ->
		@_populateSubscription dispatch.subscription
		.then (subscription) =>
			@_increaseUsedCredits subscription
		.then (subscription) =>
			if subscription.usedCredits is subscription.totalCredits
				@_removeDispatchable dispatch._id
			else
				@_updateDeliveryDate dispatch


	next: (programId, keywords = []) ->
		q = @_getModel 'Dispatch'
		.where program: programId

		if keywords.length
			q = q
			.where 'keywords'
			.in keywords
		q.sort lastDeliveredOn: 'asc'
		.findOne().execQ().then (dispatch) =>
			if dispatch
				@_postDispatch dispatch
				return dispatch.markup
			""

	subscriptionCreated: (subscriptionId) ->
		@_populateSubscription subscriptionId
		.then (subscriptionP) =>
			@_createDispatchable subscriptionP

	subscriptionUpdated: (subscriptionId) ->
		@_removeDispatchable subscriptionId
		.then =>
			@subscriptionCreated subscriptionId

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

annotate Dispatcher, new Inject ModelFactory, DotProvider, CleanCssProvider
module.exports = Dispatcher