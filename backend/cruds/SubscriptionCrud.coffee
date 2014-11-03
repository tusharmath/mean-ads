BaseCrud = require './BaseCrud'

class SubscriptionCrud
	constructor: () ->
	preCreate: (subscription) ->
		@Models.Campaign
		.findByIdQ subscription.campaign
		.then (camp) ->
			subscription.campaignProgramId = camp.program
			subscription.campaignKeywords = camp.keywords
			subscription
module.exports = SubscriptionCrud
