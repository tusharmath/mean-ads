BaseCrud = require './BaseCrud'

class SubscriptionCrud
	constructor: () ->
	_updateSubscription: (subscription, campaign) ->
		subscription.program = campaign.program
		subscription.keywords = campaign.keywords
		expiryDate = new Date
		expiryDate.setDate expiryDate.getDate() + campaign.days
		subscription.endDate = expiryDate
		subscription

	preCreate: (subscription) ->
		@Models.Campaign
		.findByIdQ subscription.campaign
		.then (campaign) =>
			@_updateSubscription subscription, campaign
module.exports = SubscriptionCrud
