define ["app", "lodash"], (app, _) ->
	class CampaignAlterCtrl
		constructor: (@rest, @route, @alter) ->
			@mode = 'create'
			if @route.id
				rest.one('campaigns', @route.id).get().then (@campaign) =>
				@mode = 'update'
			rest.all('programs').getList().then (@programs) =>

		save: () ->
			if @campaign.keywords instanceof Array is no
				@campaign.keywords = _.compact @campaign.keywords.split /[\s,.|]/
			@alter.persist 'campaigns', @campaign

	CampaignAlterCtrl.$inject = [
		"Restangular" , '$routeParams', 'AlterPersistenceService'
	]
	app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
