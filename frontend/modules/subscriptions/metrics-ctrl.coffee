define ["app"], (app) ->
	class CampaignMetricsCtrl
		constructor: (@rest) ->
			@rest.all('campaigns').getList().then (@campaigns) =>

		toggleStatus: (campaign) ->
			@rest
			.one 'campaigns', campaign._id
			.patch isEnabled: !!!campaign.isEnabled
			.then => @rest.all('campaigns').getList().then (@campaigns) =>

	CampaignMetricsCtrl.$inject = ['Restangular']
	app.controller 'CampaignMetricsCtrl', CampaignMetricsCtrl
