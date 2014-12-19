BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'
DispatchStamper = require '../modules/DispatchStamper'
config = require '../config/config'
Q = require 'q'
_ = require 'lodash'
{annotate, Inject} = require 'di'

class SubscriptionController
	constructor: (@dispatch, @actions, stamper) ->
		@_populate = path: 'campaign', select: 'name'
		# Filter Keys
		@actions._filterKeys = ['campaign']
		@actions.resourceName = 'Subscription'

		# Setting up custom routes
		@actions.actionMap.$credits = ['get', (str) -> "/core/#{str}s/credits"]
		@actions.actionMap.$convert = ['get', (str) -> "/#{str}/:id/convert"]

		@actions.postUpdateHook = @postUpdateHook
		@actions.postCreateHook = @postCreateHook

		@actions.$credits = @$credits
		@actions.$convert = (req, res) ->
			res.set 'Access-Control-Allow-Origin', '*'
			return Q null if not stamper.isConvertableSubscription req.signedCookies._sub, req.params.id
			Subscription = @getModel()
			Subscription.findByIdQ req.params.id
			.then (subscription) ->
				Subscription.findByIdAndUpdate subscription._id, conversions: subscription.conversions + 1
				.execQ()

	postCreateHook: (subscription) =>
		@dispatch.subscriptionCreated subscription._id
		.then -> subscription

	postUpdateHook: (subscription) =>
		@dispatch.subscriptionUpdated subscription._id
		.then -> subscription

	$credits: (req) ->
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
annotate SubscriptionController, new Inject Dispatcher, BaseController, DispatchStamper
module.exports = SubscriptionController
