config = require '../config/config'
Q = require 'q'
_ = require 'lodash'
{ErrorPool} = require '../config/error-codes'

class SubscriptionController
	constructor: (@dispatch, @actions, @mailer) ->
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
		@actions.actionMap.$convert = ['get', (str) -> "/#{str}/:id/convert.gif"]
		@actions.actionMap.$clickAck = ['get', (str) -> "/#{str}/:id/ack"]

		@actions.postUpdateHook = @postUpdateHook
		@actions.postCreateHook = @postCreateHook
		@actions.$credits = @$credits
		@actions.$convert = @$convert
		@actions.$email = @$email
		@actions.$clickAck = @$clickAck

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
	#TODO: Resolve with a fake image
	$convert: (req, res) =>
		# Call conversion logic
		@_convertQ(req).done()
		# Resolve with a transparent image
		res.set 'Content-Type', config.transparentGif.contentType
		Q config.transparentGif.image

	_convertQ: (req) ->
		Subscription = @actions.getModel()
		Subscription.findByIdQ req.params.id
		.then (subscription) ->
			Subscription.findByIdAndUpdate subscription._id, conversions: subscription.conversions + 1
			.execQ()
	_clickAckQ: (id) ->
		model = @actions.getModel()
		.findByIdQ id
		.then (subscription) ->
			return if not subscription
			subscription.clicks++
			subscription.saveQ()

	$clickAck: (req, res) =>
		if not req.query.uri
			throw ErrorPool.INVALID_PARAMETERS
		@_clickAckQ req.params.id
		.done()
		res.set 'Location', req.query.uri
		res.status 302
		Q null

module.exports = SubscriptionController
