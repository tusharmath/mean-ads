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

	_increaseUsedCredits: (subscription) ->
		@_getModel 'Subscription'
		.findByIdAndUpdate subscription._id, usedCredits: subscription.usedCredits + 1
		.execQ()

	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @date.now()
		.execQ()
	delivered: (dispatch) ->
		@subPopulator.populateSubscription dispatch.subscription
		.then (subscription) =>
			@_increaseUsedCredits subscription
		.then (subscription) =>
			if subscription.hasCredits
				@_updateDeliveryDate dispatch
			else
				@dispatchFac.removeForSubscriptionId subscription._id

annotate DispatchPostDelivery, new Inject(
	ModelFactory
	DotProvider
	DateProvder
	SubscriptionPopulator
	DispatchFactory
	)
module.exports = DispatchPostDelivery