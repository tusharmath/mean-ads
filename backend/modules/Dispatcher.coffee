ModelFactory = require '../factories/ModelFactory'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac) ->

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

	subscriptionCreated: (subscription) ->
	subscriptionUpdated: ->
	campaignUpdated: ->
	programUpdated: ->

annotate Dispatcher, new Inject ModelFactory
module.exports = Dispatcher