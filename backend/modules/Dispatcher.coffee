ModelFactory = require '../factories/ModelFactory'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @css) ->

	next: (programId, keywords = []) ->

	_getModel: (name) -> @modelFac.Models[name]
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
		{html, css} = subscription.campaign.program.style
		_html = @dot.template(html) subscription.data
		_html = "<style>#{@css.minify css}</style>#{_html}" if css
		_html
	_createDispatchable: (subscription) ->
		Dispatch = @_getModel 'Dispatch'
		new Dispatch(
			markup: @_interpolateMarkup subscription
			subscription: subscription._id
			program: subscription.campaign.program._id
			keywords: subscription.campaign.keywords
			)
		.saveQ()
	_removeDispatchable: (subscriptionId) ->
		@_getModel 'Dispatch'
		.remove subscription: subscriptionId
		.execQ()

	subscriptionCreated: (subscriptionId) ->
	subscriptionUpdated: (subscriptionId) ->
	campaignUpdated: (campaignId) ->
	programUpdated: (programId) ->

annotate Dispatcher, new Inject ModelFactory, DotProvider, CleanCssProvider
module.exports = Dispatcher