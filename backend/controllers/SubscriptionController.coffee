BaseController = require './BaseController'
Q = require 'q'
_ = require 'lodash'

class SubscriptionController
	constructor: () ->
		@_populate = path: 'campaign', select: 'name'
		@_filterKeys = ['campaign']

	# TODO: Can't think of a better way to handle custom routes
	actionMap:
		$credits: ['get', -> '/core/subscriptions/credits']
		###
			Get an Ad, on query param
			Get Links to CSS
			Get Link to Markup
		####
		$ad: [ 'get', -> '/dispatch/ad']

		###
			Cacheable Style CSS
		###
		$css: [ 'get', -> '/dispatch/css/:styleId']

		###
			Cacheable Style Markup
		###
		$markup: [ 'get', -> '/dispatch/markup/:styleId']

	# _updateSubscriptionDeliveryDate:  ->
	$ad: (req, res) ->
		@crud.query()
		.where campaignProgramId: req.query.p
		.sort lastDeliveredOn: 'asc'
		.findOne ''
		.execQ()
		.then (subscription) ->
			subscription.lastDeliveredOn = Date.now()
			subscription.save()
			subscription.data


	$credits: (req, res) =>
		filter = req.query
		filter.owner = req.user.sub
		@crud
		.read '', req.query
		.done (data) ->
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
			res.send {creditDistribution, creditUsage}

	# Perfect place to mutate request
module.exports = SubscriptionController
