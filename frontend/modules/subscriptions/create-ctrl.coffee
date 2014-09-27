define ["app"], (app) ->
	class SubscriptionCreateCtrl
		constructor: (@rest, @loc) ->
			@subscription = data:{}
			rest.all('campaigns').getList().then (@campaigns) =>
		save: () ->
			@rest
			.all 'subscriptions'
			.post @subscription
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



	SubscriptionCreateCtrl.$inject = ["Restangular", "$location"]
	app.controller 'SubscriptionCreateCtrl', SubscriptionCreateCtrl
