BaseCrud = require './BaseCrud'
_ = require 'lodash'
class CampaignCrud
	constructor: () ->
	CampaignCrud:: = injector.get BaseCrud
	postUpdate: (camp) ->
		@models
		.Subscription
		.findQ campaign: camp._id
		.done (subs) ->
			_.each subs, (sub) ->
				subs.campaignKeywords = camp.campaignKeywords
				subs.save()

module.exports = CampaignCrud
