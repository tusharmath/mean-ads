ModelFactory = require '../factories/ModelFactory'
DispatchFactory = require '../factories/DispatchFactory'
SubscriptionPopulator = require './SubscriptionPopulator'
Q = require 'q'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
less = require 'less'
_ = require 'lodash'
# {annotate, Inject} = require 'di'

# Round Robin DispatchPostDelivery
class DispatchPostDelivery
	constructor: (@models, @dot, @date, @subPopulator, @dispatchFac) ->
	_getModel: (name) -> @models[name]
	# TODO: Could be a part of the campaign schema
	_getImpressionCost: (subscriptionP, keywords) ->
		defaultCost = subscriptionP.campaign.defaultCost / 1000
		keywordPricing = _.filter subscriptionP.campaign.keywordPricing, (i) ->
			_.any keywords, (j) -> j is i.keyName
		if keywordPricing.length is 0
			defaultCost
		else
			_.max(keywordPricing, (i) -> i.keyPrice).keyPrice/1000

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
	delivered: (dispatch, keywords) ->
		@subPopulator.populateSubscription dispatch.subscription
		.then (subscriptionP) =>
			if subscriptionP is null
				@dispatchFac.removeForSubscriptionId dispatch.subscription
			else
				cost = @_getImpressionCost subscriptionP, keywords
				@_increaseUsedCredits subscriptionP, cost
				.then (subscriptionP) =>
					if subscriptionP.hasCredits
						@_updateDeliveryDate dispatch
					else
						@dispatchFac.removeForSubscriptionId subscriptionP._id

# annotate DispatchPostDelivery, new Inject(
# 	ModelFactory
# 	DotProvider
# 	DateProvder
# 	SubscriptionPopulator
# 	DispatchFactory
# 	)
module.exports = DispatchPostDelivery
