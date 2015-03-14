Q = require 'q'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'
config = require '../config/config'

# Round Robin DispatchFactory
class DispatchFactory
	constructor: (@models, @dot, @htmlMinify, @date, @subPopulator) ->
	_elPrefix: (key)-> "ae-#{key}"
	_getModel: (name) -> @models[name]
	# Created so that dates can be mocked in the tests
	_attachRedirectURI: (subscription) ->
		_.each subscription.data, (value, field) ->
			if field.match /_uri/
				subscription.data[field] = "//#{config.appHost}/api/v1/subscription/#{subscription._id}/ack?uri=#{value}"

	# TODO: Move it to a provider
	_interpolateMarkup: (subscription) ->
		@_attachRedirectURI subscription
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
			if not css or css is ''
				out = _markup
			else
				out = "<style>#{css}</style>#{_markup}"
			@htmlMinify.minify out
	_createDispatchable: (subscription) ->
		{campaign} = subscription
		{program} = campaign
		return Q null if (
			campaign.isEnabled is false or
			subscription.hasCredits is false
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
				keywords: subscription.keywords
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
	require './ModelFactory'
	require '../providers/DotProvider'
	require '../providers/HtmlMinifierProvider'
	require '../providers/DateProvider'
	require '../modules/SubscriptionPopulator'
	)
module.exports = DispatchFactory