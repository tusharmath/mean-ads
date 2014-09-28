define ["app", "lodash"], (app, _) ->
	class CampaignAlterCtrl
		constructor: (@rest, @loc, @route) ->
			rest.one('campaigns', @route.id).get().then (@campaign) =>
			rest.all('programs').getList().then (@programs) =>
		save: () ->
			if @campaign.keywords instanceof Array is no
				@campaign.keywords = _.compact @campaign.keywords.split /[\s,.|]/
			@rest
			.one 'campaigns', @campaign._id
			.patch @campaign
			.then () => @loc.path '/campaigns'

	CampaignAlterCtrl.$inject = ["Restangular", "$location" , '$routeParams']
	app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
