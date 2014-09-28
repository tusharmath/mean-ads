define ["app"], (app) ->
	class SubscriptionAlterCtrl

		constructor: (@rest, @alter, @route) ->
			@subscription = @first.load 'subscriptions'
			@rest.all('campaigns').getList().then (@campaigns) =>
				do @onCampaignSelect

		save: () -> @alter.persist 'styles', @style

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
		"Restangular", "AlterPersistenceService", '$routeParams'
	]
	app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
