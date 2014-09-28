define ["app", "lodash"], (app, _) ->
	class CampaignAlterCtrl
		constructor: (@rest, @route, @alter) ->
			@campaign = @first.load 'campaigns'
			rest.all('programs').getList().then (@programs) =>

		save: () ->
			if @campaign.keywords instanceof Array is false
				@campaign.keywords = _.compact @campaign.keywords.split /[\s,.|]/
			@alter.persist 'campaigns', @campaign

	CampaignAlterCtrl.$inject = [
		"Restangular" , '$routeParams', 'AlterPersistenceService'
	]
	app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
