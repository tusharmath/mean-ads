ModelFactory = require '../factories/ModelFactory'
Q = require 'q'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin SubscriptionPopulator
class SubscriptionPopulator
	constructor: (@modelFac) ->
	_getModel: (name) -> @modelFac.models()[name]
	populateSubscription: (subscriptionId) ->
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

annotate SubscriptionPopulator, new Inject ModelFactory
module.exports = SubscriptionPopulator