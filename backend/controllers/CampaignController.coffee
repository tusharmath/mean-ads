BaseController = require './BaseController'
ModelManager = require '../models'
di = require 'di'

class CampaignController
	constructor: (@modelManager) ->
		@model = @modelManager.models.CampaignModel
	CampaignController:: = injector.get BaseController

	list: (req, res) ->

		@subscriptionModel = @modelManager.models.SubscriptionModel
		@model
		.find {}
		.populate path: 'program', select: 'name gauge'
		.limit 10
		.exec (err, data) ->
			return res.send err, 400 if err
			for campaign in data
				campaign.performance = Math.floor(Math.random() * 100)

			res.send data
di.annotate CampaignController, new di.Inject ModelManager

module.exports = CampaignController
