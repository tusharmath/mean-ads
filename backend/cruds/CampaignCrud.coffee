BaseCrud = require './BaseCrud'
_ = require 'lodash'
class CampaignCrud
	constructor: () ->
	_setCampaignKeywords: (subs, camp) ->
		_.each subs, (sub) ->
			sub.campaignKeywords = camp.campaignKeywords
			sub.save()

	postUpdate: (camp) ->
		@Models
		.Subscription
		.findQ campaign: camp._id
		.then (subs) => @_setCampaignKeywords subs, camp

module.exports = CampaignCrud
