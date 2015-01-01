ModelFactory = require './ModelFactory'
Utils = require '../Utils'
Q = require 'q'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
SubscriptionPopulator = require '../modules/SubscriptionPopulator'
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
	removeForSubscriptionId: (subscriptionId) ->
		@_getModel 'Dispatch'
		.find subscription: subscriptionId
		.remove()
		.execQ()

	createForSubscriptionId: (subscriptionId) ->
		@subPopulator.populateSubscription subscriptionId
		.then (subscription) =>
			@_createDispatchable subscription

	updateForSubscriptionId: (subscriptionId) ->
		@removeForSubscriptionId subscriptionId
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