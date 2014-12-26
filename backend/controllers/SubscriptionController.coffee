BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'
DispatchStamper = require '../modules/DispatchStamper'
Mailer = require '../modules/Mailer'
config = require '../config/config'
Q = require 'q'
_ = require 'lodash'
{annotate, Inject} = require 'di'

class SubscriptionController
	constructor: (@dispatch, @actions, @stamper, @mailer) ->
		@_populate = path: 'campaign', select: 'name'
		# Filter Keys
		@actions._filterKeys = ['campaign']
		@actions.resourceName = 'Subscription'
		# TODO: Find a better way to do this
		# Setting up custom routes

		# CORE
		@actions.actionMap.$credits = ['get', (str) -> "/core/#{str}s/credits"]
		@actions.actionMap.$email = ['post', (str) -> "/core/#{str}/:id/email"]

		# OPEN
		@actions.actionMap.$convert = ['get', (str) -> "/#{str}/:id/convert"]

		@actions.postUpdateHook = @postUpdateHook
		@actions.postCreateHook = @postCreateHook
		@actions.$credits = @$credits
		@actions.$convert = @$convert
		@actions.$email = @$email

	postCreateHook: (subscription) =>
		@dispatch.subscriptionCreated subscription._id
		.then -> subscription

	postUpdateHook: (subscription) =>
		@dispatch.subscriptionUpdated subscription._id
		.then -> subscription
	_emailQ: (subscription, toEmail) ->
		mail =
			from: config.mailgun.noReplyEmail
			to: toEmail
			subject: "Performance report of your subscription #{subscription._id}"
			template: 'subscription-report'
			locals: {subscription}
		@mailer.sendQ mail

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
	$email: (req, res) =>
		@actions.getModel().findByIdQ req.params.id
		.then (subscription) =>
			Q.all _.map subscription.emailAccess, (email) =>
				@_emailQ subscription, email
	$convert: (req, res) =>
		res.set 'Access-Control-Allow-Origin', '*'
		return Q null if not @stamper.isConvertableSubscription req.signedCookies._sub, req.params.id
		Subscription = @actions.getModel()
		Subscription.findByIdQ req.params.id
		.then (subscription) ->
			Subscription.findByIdAndUpdate subscription._id, conversions: subscription.conversions + 1
			.execQ()
	# Perfect place to mutate request
annotate SubscriptionController, new Inject Dispatcher, BaseController, DispatchStamper, Mailer
module.exports = SubscriptionController
