BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'
Q = require 'q'
_ = require 'lodash'
{annotate, Inject} = require 'di'

class SubscriptionController
	constructor: (@dispatch, @actions) ->
		@_populate = path: 'campaign', select: 'name'
		# Filter Keys
		@actions._filterKeys = ['campaign']
		@actions.resourceName = 'Subscription'

		# Setting up custom routes
		@actions.actionMap.$credits = ['get', (str) -> "/core/#{str}s/credits"]
		@actions.actionMap.$convert = ['patch', (str) -> "/#{str}/:id/convert"]

		@actions.$credits = @$credits
		@actions.$convert = @$convert
		@actions.postUpdateHook = @postUpdateHook
		@actions.postCreateHook = @postCreateHook

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
	$convert: (req) ->
		Subscription = @getModel()
		Subscription.findByIdQ req.s
		.then (subscription) ->
			Subscription.findByIdAndUpdate subscription._id, conversions: subscription.conversions + 1
			.execQ()

	# Perfect place to mutate request
annotate SubscriptionController, new Inject Dispatcher, BaseController
module.exports = SubscriptionController
