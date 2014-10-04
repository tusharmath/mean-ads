_ = require 'lodash'
BaseController = require './BaseController'

class CampaignController
	constructor: () ->
		@model = @modelManager.models.Campaign
		@_populate = path: 'program', select: 'name gauge'
	CampaignController:: = injector.get BaseController

	# TODO: Can't think of a better way to handle custom routes
	actionMap:
		$credits: ['get', -> '/campaigns/:id/credits']

	$credits: (req, res) ->
		sub = @modelManager.models.SubscriptionModel
		sub
		.find campaign: req.params.id
		.exec (err, data) ->
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


module.exports = CampaignController
