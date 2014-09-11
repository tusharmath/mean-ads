ModelManager = require '../models'
di = require 'di'
_ = require 'lodash'

class AdController
	constructor: (@modelManager) ->
		@model = @modelManager.models.SubscriptionModel

	first: (req, res) ->
		@campaignModel = @modelManager.models.CampaignModel
		@programModel = @modelManager.models.ProgramModel
		@styleModel = @modelManager.models.StyleModel
		@campaignModel
		.findOne
			$and: [
				'program': req.params.id
				keywords: $in : req.query.keywords
			]
		.exec (err, keywordCampaignData) =>
			return res.jsonp [] if not keywordCampaignData
			@model
			.where 'campaign'
			.equals keywordCampaignData._id
			.exec (err, data) =>
				min = 0
				max = data.length
				return res.send [] if data.length == 0
				randomIndex = Math.floor(Math.random() * (max - min) + min)
				@campaignModel
				.findById data[randomIndex].campaign
				.exec (err, campaignData) =>
					@programModel
					.findById campaignData.program
					.exec (err, programData) =>
						@styleModel
						.findById programData.style
						.exec (err, styleData) =>
							{html, css} = styleData
							{data, _id} = data[randomIndex]
							return res.send err, 400 if err
							res.jsonp {html, css, data, _id}
				@model
				.findByIdAndUpdate data[randomIndex]._id, creditsRemaining: data[randomIndex].creditsRemaining - 1
				.exec (err, data) =>


di.annotate AdController, new di.Inject ModelManager

module.exports = AdController
