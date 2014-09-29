define ["app", "lodash"], (app, _) ->
	class CampaignAlterCtrl
		constructor: (@rest, @alter) ->

			@alter.bootstrap @, 'campaign'

			rest.all('programs').getList().then (@programs) =>

		beforeSave: () ->
			@campaign.keywords = @tok.tokenize @campaign.keywords

	CampaignAlterCtrl.$inject = [
		"Restangular" , 'AlterControllerExtensionService'
	]
	app.controller 'CampaignAlterCtrl', CampaignAlterCtrl
