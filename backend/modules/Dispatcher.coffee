ModelFactory = require '../factories/ModelFactory'
Q = require 'q'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @css, @date) ->
	_elPrefix: (key)-> "ae-#{key}"
	_getModel: (name) -> @modelFac.models()[name]
	# Created so that dates can be mocked in the tests
	# TODO: Move it to a provider
	_getCurrentDate: -> @date.now()
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
		# Required fields
		{data} = subscription
		{html,css, _id} = subscription.campaign.program.style

		# Getting the css selector name
		el = @_elPrefix _id

		# Wrapping the html markup
		_wrappedHtml = "<div class=\"#{el}\">#{html}</div>"

		# Creating HTML markup from template
		_markup = @dot.template(_wrappedHtml) data
		lessCss = ".#{el} { #{css or ''} }"
		less.render lessCss
		.then (renderedCss) =>
			{css} = renderedCss

			# Final Output
			return _markup if not css or css is ''
			"<style>#{@css.minify css}</style>#{_markup}"
	# TODO: Util function must go out
	_hasSubscriptionExpired: (subscription) ->
		{startDate} = subscription
		[year, month, date] = @date.split startDate

		date += subscription.campaign.days
		endDate = @date.create year, month, date
		if endDate  < @_getCurrentDate() then yes else no
	_createDispatchable: (subscription) ->
		{campaign} = subscription
		{program} = campaign
		subExpired = @_hasSubscriptionExpired subscription
		return Q null if (
			subExpired is yes or
			campaign.isEnabled is false or
			subscription.totalCredits is subscription.usedCredits
			)
		Dispatch = @_getModel 'Dispatch'
		@_interpolateMarkup subscription
		.then (markup) ->

			new Dispatch(
				markup: markup
				subscription: subscription._id
				program: program._id
				allowedOrigins: program.allowedOrigins
				keywords: campaign.keywords
				)
			.saveQ()
	# Removes all dispatchable with a subscriptionId
	_removeDispatchable: (subscriptionId) ->
		@_getModel 'Dispatch'
		.find subscription: subscriptionId
		.remove()
		.execQ()
	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @_getCurrentDate()
		.execQ()
	_postDispatch: (dispatch) ->
		@_populateSubscription dispatch.subscription
		.then (subscription) =>
			@_increaseUsedCredits subscription
		.then (subscription) =>
			subExpired = @_hasSubscriptionExpired subscription
			if (
				subExpired is yes or
				subscription.usedCredits is subscription.totalCredits
			)
				@_removeDispatchable subscription._id
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
				.done()
				return dispatch
			null

	subscriptionCreated: (subscriptionId) ->
		@_populateSubscription subscriptionId
		.then (subscription) =>
			@_createDispatchable subscription

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

annotate Dispatcher, new Inject ModelFactory, DotProvider, CleanCssProvider, DateProvder
module.exports = Dispatcher