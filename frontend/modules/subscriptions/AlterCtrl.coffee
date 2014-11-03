define ["app"], (app) ->
	class SubscriptionAlterCtrl

		constructor: (@rest, @alter, @q) ->

			@alter.bootstrap @, 'subscription'

			@rest.all('campaigns').getList().then (@campaigns) =>
				do @onCampaignSelect

		_loadCampaign: =>
			@rest
			.one 'campaign', @subscription.campaign
			.get()

		_loadProgram: (@campaign) =>
			@rest
			.one 'program', @campaign.program
			.get()

		_loadStyle: (@program) =>
			@rest.one 'style', @program.style
			.get()
			.then (@style) =>

		onCampaignSelect: () =>
			@_loadCampaign()
			.then @_loadProgram
			.then @_loadStyle

	SubscriptionAlterCtrl.$inject = [
		"Restangular", "AlterControllerExtensionService", '$q'
	]
	app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
