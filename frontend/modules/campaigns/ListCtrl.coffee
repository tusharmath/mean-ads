app = require '../../app'
class CampaignCtrl
	constructor: (@rest) ->
		@_getCampaigns()

	_getCampaigns: =>
		@rest.all('campaigns')
		.getList(populate: 'program')
		.then (@campaigns) =>

	toggleStatus: (campaign) ->
		@rest
		.one 'campaign', campaign._id
		.patch isEnabled: !!!campaign.isEnabled
		.then @_getCampaigns

CampaignCtrl.$inject = ['Restangular']
app.controller 'CampaignListCtrl', CampaignCtrl
