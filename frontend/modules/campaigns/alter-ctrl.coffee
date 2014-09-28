define ["app", "lodash"], (app, _) ->
	class CampaignAlterCtrl
		constructor: (@rest, @alter) ->

			@alter.bootstrap @, 'campaign'

			rest.all('programs').getList().then (@programs) =>

		beforeSave: () ->
			if @campaign.keywords instanceof Array is false
				@campaign.keywords = _.compact @campaign.keywords.split /[\s,.|]/

	CampaignAlterCtrl.$inject = [
		"Restangular" , 'AlterControllerExtensionService'
	]
	app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
