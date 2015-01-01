ModelFactory = require '../factories/ModelFactory'
DispatchFactory = require '../factories/DispatchFactory'
SubscriptionPopulator = require './SubscriptionPopulator'
Utils = require '../Utils'
Q = require 'q'
CleanCssProvider = require '../providers/CleanCssProvider'
DotProvider = require '../providers/DotProvider'
DateProvder = require '../providers/DateProvider'
less = require 'less'
_ = require 'lodash'
{annotate, Inject} = require 'di'

# Round Robin Dispatcher
class Dispatcher
	constructor: (@modelFac, @dot, @css, @date, @subPopulator, @utils, @dispatchFac) ->
	_getModel: (name) -> @modelFac.models()[name]

	_increaseUsedCredits: (subscription) ->
		@_getModel 'Subscription'
		.findByIdAndUpdate subscription._id, usedCredits: subscription.usedCredits + 1
		.execQ()

	_updateDeliveryDate: (dispatch) ->
		@_getModel 'Dispatch'
		.findByIdAndUpdate dispatch._id, lastDeliveredOn:  @date.now()
		.execQ()
	_postDelivery: (dispatch) ->
		@subPopulator.populateSubscription dispatch.subscription
		.then (subscription) =>
			@_increaseUsedCredits subscription
		.then (subscription) =>
			subExpired = @utils.hasSubscriptionExpired subscription
			if (
				subExpired is yes or
				subscription.usedCredits is subscription.totalCredits
			)
				@dispatchFac._removeDispatchable subscription._id
			else
				@_updateDeliveryDate dispatch

annotate Dispatcher, new Inject(
	ModelFactory
	DotProvider
	CleanCssProvider
	DateProvder
	SubscriptionPopulator
	Utils
	DispatchFactory
	)
module.exports = Dispatcher