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

	$credits: (req, res) =>
		filter = req.query
		filter.owner = req.user.sub
		@crud
		.read '', req.query
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
module.exports = SubscriptionController
