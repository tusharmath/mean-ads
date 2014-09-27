define ["app"], (app) ->
	class SubscriptionUpdateCtrl

		constructor: (@rest, @loc, @route) ->
			@rest.one 'subscriptions', @route.id
			.get()
			.then (@subscription) =>
			@rest.all('campaigns').getList().then (@campaigns) =>
				do @onCampaignSelect
		save: () ->
			@rest
			.one 'subscriptions', @subscription._id
			.patch @subscription
			.then () =>
				@loc.path '/subscriptions'

		onCampaignSelect: () =>
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

	SubscriptionUpdateCtrl.$inject = ["Restangular", "$location", '$routeParams']
	app.controller 'SubscriptionUpdateCtrl', SubscriptionUpdateCtrl
