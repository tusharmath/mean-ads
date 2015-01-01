ModelFactory = require '../factories/ModelFactory'
Utils = require '../Utils'
Q = require 'q'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
SubscriptionPopulator = require './SubscriptionPopulator'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin DispatchFactory
class DispatchFactory
	constructor: (@modelFac, @dot, @css, @date, @utils, @subPopulator) ->
	_elPrefix: (key)-> "ae-#{key}"
	_getModel: (name) -> @modelFac.models()[name]
	# Created so that dates can be mocked in the tests
	# TODO: Move it to a provider
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
	_createDispatchable: (subscription) ->
		{campaign} = subscription
		{program} = campaign
		subExpired = @utils.hasSubscriptionExpired subscription
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
				startDate: subscription.startDate
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
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @date.now()
		.execQ()
	_postDispatch: (dispatch) ->
		@_populateSubscription dispatch.subscription
		.then (subscription) =>
			@_increaseUsedCredits subscription
		.then (subscription) =>
			subExpired = @utils.hasSubscriptionExpired subscription
			if (
				subExpired is yes or
				subscription.usedCredits is subscription.totalCredits
			)
				@_removeDispatchable subscription._id
			else
				@_updateDeliveryDate dispatch

	createForSubscriptionId: (subscriptionId) ->
		@_populateSubscription subscriptionId
		.then (subscription) =>
			@_createDispatchable subscription

	updateForSubscriptionId: (subscriptionId) ->
		@_removeDispatchable subscriptionId
		.then =>
			@createForSubscriptionId subscriptionId
annotate DispatchFactory, new Inject(
	ModelFactory
	DotProvider
	CleanCssProvider
	DateProvder
	Utils
	SubscriptionPopulator
	)
module.exports = DispatchFactory