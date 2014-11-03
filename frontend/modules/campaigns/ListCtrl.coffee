define ["app"], (app) ->
	class CampaignCtrl
		constructor: (@rest) ->
			@rest.all('campaigns').getList(populate: 'program').then (@campaigns) =>

		toggleStatus: (campaign) ->
			@rest
			.one 'campaigns', campaign._id
			.patch isEnabled: !!!campaign.isEnabled
			.then => @rest.all('campaigns').getList().then (@campaigns) =>

	CampaignCtrl.$inject = ['Restangular']
	app.controller 'CampaignListCtrl', CampaignCtrl
