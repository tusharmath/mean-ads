define ["app"], (app) ->
	class SubscriptionAlterCtrl

		constructor: (@rest, @alter) ->

			@alter.bootstrap @, 'subscription'

			@rest.all('campaigns').getList().then (@campaigns) =>
				do @onCampaignSelect

		onCampaignSelect: () =>
			# TODO: Callback hell
			@rest
			.one 'campaigns', @subscription.campaign
			.get()
			.then (@campaign) =>
				@rest
				.one 'programs', @campaign.program
				.get()
				.then (@program) =>
					@rest.one 'styles', @program.style
					.get()
					.then (@style) =>

	SubscriptionAlterCtrl.$inject = [
		"Restangular", "AlterControllerExtensionService"
	]
	app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
