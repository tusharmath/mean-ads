ModelFactory = require '../factories/ModelFactory'
DispatchFactory = require '../factories/DispatchFactory'
SubscriptionPopulator = require './SubscriptionPopulator'
Utils = require '../Utils'
Q = require 'q'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @date, @subPopulator, @utils, @dispatchFac) ->
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
			subExpired = @utils.hasSubscriptionExpired subscription
			if (
				subExpired is yes or
				subscription.usedCredits is subscription.totalCredits
			)
				@dispatchFac.removeForSubscriptionId subscription._id
			else
				@_updateDeliveryDate dispatch

annotate Dispatcher, new Inject(
	ModelFactory
	DotProvider
	DateProvder
	SubscriptionPopulator
	Utils
	DispatchFactory
	)
module.exports = Dispatcher