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
	_getImpressionCost: (subscriptionP, keyword) ->
		{keywordPricing} = subscriptionP.campaign
		keywordPrice = _.find keywordPricing, (kp) -> kp.keyName is keyword
		if keywordPrice
			keywordPrice.keyPrice / 1000
		else
			subscriptionP.campaign.defaultCost / 1000
	# TODO: Rename function
	_increaseUsedCredits: (subscriptionP, cost = 0) ->
		delta = usedCredits: subscriptionP.usedCredits + cost
		delta.impressions = subscriptionP.impressions + 1
		@_getModel 'Subscription'
		.findByIdAndUpdate subscriptionP._id, delta
		.execQ()

	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @date.now()
		.execQ()
	# TODO: too slanty
	delivered: (dispatch) ->
		@subPopulator.populateSubscription dispatch.subscription
		.then (subscriptionP) =>
			if subscriptionP is null
				@dispatchFac.removeForSubscriptionId dispatch.subscription
			else
				cost = @_getImpressionCost subscriptionP
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