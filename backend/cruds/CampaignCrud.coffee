Q = require 'q'
BaseCrud = require './BaseCrud'
_ = require 'lodash'
class CampaignCrud
	constructor: () ->
	_keywordUpdateMapper: (sub, camp) ->
		patch =
			keywords: camp.keywords
			program: camp.program
		sub.updateQ patch
	_setCampaignKeywords: (subs, camp) ->
		Q.all _.map subs, (sub) => @_keywordUpdateMapper sub, camp

	postUpdate: (camp) ->
		throw Error 'Campaign must have [_id] field' if not camp._id
		@Models
		.Subscription
		.findQ campaign: camp._id
		.then (subs) =>
			@_setCampaignKeywords subs, camp

module.exports = CampaignCrud
