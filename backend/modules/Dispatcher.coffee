ModelFactory = require '../factories/ModelFactory'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @css) ->

	next: (programId, keywords = []) ->

	_getModel: (name) -> @modelFac.Models[name]
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
		{html, css} = subscription.campaign.program.style
		_html = @dot.template(html) subscription.data
		_css = @css.minify css
		"<style>#{_css}</style>#{_html}"
	subscriptionCreated: (subscription) ->
	subscriptionUpdated: ->
	campaignUpdated: ->
	programUpdated: ->

annotate Dispatcher, new Inject ModelFactory, DotProvider, CleanCssProvider
module.exports = Dispatcher