BaseCrud = require './BaseCrud'

class SubscriptionCrud
	constructor: () ->
	SubscriptionCrud:: = injector.get BaseCrud
	preCreate: (subscription) ->
		@models.Campaign
		.findByIdQ subscription.campaign
		.then (camp) ->
			subscription.campaignProgramId = camp.program
			subscription.campaignKeywords = camp.keywords
			subscription
module.exports = SubscriptionCrud
