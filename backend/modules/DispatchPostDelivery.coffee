ModelFactory = require '../factories/ModelFactory'
DispatchFactory = require '../factories/DispatchFactory'
SubscriptionPopulator = require './SubscriptionPopulator'
Q = require 'q'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin DispatchPostDelivery
class DispatchPostDelivery
	constructor: (@modelFac, @dot, @date, @subPopulator, @dispatchFac) ->
	_getModel: (name) -> @modelFac.models()[name]
	# TODO: Could be a part of the campaign schema
	_getSubscriptionCost: (subscriptionP, keyword) ->
		{keywordPricing} = subscriptionP.campaign
		keywordPrice = _.find keywordPricing, (kp) -> kp.keyName is keyword
		return keywordPrice.keyPrice if keywordPrice
		subscriptionP.campaign.defaultCost
	_increaseUsedCredits: (subscriptionP, cost = 0) ->
		cost = 0 if subscriptionP.campaign.program.pricing isnt 'CPM'
		delta = usedCredits: subscriptionP.usedCredits + cost
		delta.impressions = subscriptionP.impressions + 1
		@_getModel 'Subscription'
		.findByIdAndUpdate subscriptionP._id, delta
		.execQ()

	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @date.now()
		.execQ()
	delivered: (dispatch) ->
		@subPopulator.populateSubscription dispatch.subscription
		.then (subscriptionP) =>
			cost = @_getSubscriptionCost subscriptionP
			@_increaseUsedCredits subscriptionP, cost
		.then (subscriptionP) =>
			if subscriptionP.hasCredits
				@_updateDeliveryDate dispatch
			else
				@dispatchFac.removeForSubscriptionId subscriptionP._id

annotate DispatchPostDelivery, new Inject(
	ModelFactory
	DotProvider
	DateProvder
	SubscriptionPopulator
	DispatchFactory
	)
module.exports = DispatchPostDelivery