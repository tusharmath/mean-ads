BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'
Q = require 'q'
_ = require 'lodash'
{annotate, Inject} = require 'di'

class SubscriptionController
	constructor: (@dispatch, @actions) ->
		@_populate = path: 'campaign', select: 'name'
		@_filterKeys = ['campaign']

	# TODO: Can't think of a better way to handle custom routes
	actionMap:
		$credits: ['get', -> '/core/subscriptions/credits']
	$create: (req) ->
		_subscription = {}
		@_base.$create.call @, req
		.then (subscription) =>
			_subscription = subscription
			@dispatch.subscriptionCreated subscription._id
		.then -> _subscription

	$update: (req) ->
		_updatedResponse = {}
		@_base.$update.call @, req
		.then (updatedResponse) =>
			_updatedResponse = updatedResponse
			@dispatch.subscriptionUpdated req.params.id
		.then -> _updatedResponse

	$credits: (req) =>
		@getModel()
		.find owner: req.user.sub
		.execQ()
		.then (data) ->
			creditUsage = _.reduce(
				data
				(sum, subscription) -> sum += subscription.usedCredits
				0
			)

			creditDistribution = _.reduce(
				data
				(sum, subscription) -> sum += subscription.totalCredits
				0
			)

			{creditDistribution, creditUsage}

	# Perfect place to mutate request
annotate SubscriptionController, new Inject Dispatcher, BaseController
module.exports = SubscriptionController
