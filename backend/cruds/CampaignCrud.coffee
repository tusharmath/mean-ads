BaseCrud = require './BaseCrud'
_ = require 'lodash'
class CampaignCrud
	constructor: () ->
	postUpdate: (camp) ->
		@Models
		.Subscription
		.findQ campaign: camp._id
		.then (subs) ->
			_.each subs, (sub) ->
				subs.campaignKeywords = camp.campaignKeywords
				subs.save()

module.exports = CampaignCrud
