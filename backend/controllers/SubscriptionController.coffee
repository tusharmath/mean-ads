BaseController = require './BaseController'
Q = require 'q'

class SubscriptionController
	constructor: () ->
		@model = @modelManager.models.SubscriptionModel
		@_populate = path: 'campaign', select: 'name'
		@_filterKeys = ['campaign']
	SubscriptionController:: = base = injector.get BaseController
	# Perfect place to mutate request
	createReqMutator: (reqBody) ->
		defer = do Q.defer
		campaignModel = @modelManager.models.CampaignModel
		campaignModel
		.findById reqBody.campaign
		.exec (err, campaign) ->
			reqBody.usedCredits = 0
			{program, keywords} = campaign
			reqBody.campaignProgramId = do program.toString
			reqBody.campaignKeywords = keywords
			defer.resolve reqBody

		defer.promise

module.exports = SubscriptionController
