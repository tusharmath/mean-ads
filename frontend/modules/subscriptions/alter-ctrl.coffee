define ["app"], (app) ->
	class SubscriptionAlterCtrl

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

	SubscriptionAlterCtrl.$inject = ["Restangular", "$location", '$routeParams']
	app.controller 'SubscriptionAlterCtrl', SubscriptionAlterCtrl
