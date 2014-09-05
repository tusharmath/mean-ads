ModelManager = require '../models'
Instantiable = require '../modules/Instantiable'
di = require 'di'
_ = require 'lodash'

class AdController
	constructor: (@modelManager) ->
		@model = @modelManager.models.SubscriptionModel

	list: (req, res) ->
		@campaignModel = @modelManager.models.CampaignModel
		@programModel = @modelManager.models.ProgramModel
		@styleModel = @modelManager.models.StyleModel

		@keywordCampaignModel = @modelManager.models.CampaignModel

		@keywordCampaignModel
		.findOne()
		.where("keywords").equals(req.query.keywords)
		.limit 1
		.exec (err, keywordCampaignData) =>
			@model
			.where('campaign').equals(keywordCampaignData._id)
			.exec (err, data) =>

				min = 0
				max = data.length
				if data.length == 0
					return res.send []
				randomIndex = Math.floor(Math.random() * (max - min) + min)
				obj = {}
				@campaignModel
				.findById data[randomIndex].campaign
				.exec (err, campaignData) =>
					@programModel
					.findById campaignData.program
					.exec (err, programData) =>
						@styleModel
						.findById programData.style
						.exec (err, styleData) =>
							obj.style = styleData
							obj.subscription = data[randomIndex]
							return res.send err, 400 if err
							res.send obj


				@model
				.findByIdAndUpdate data[randomIndex]._id, creditsRemaining: data[randomIndex].creditsRemaining - 1
				.exec (err, data) =>


di.annotate AdController, new di.Inject ModelManager

module.exports = AdController
