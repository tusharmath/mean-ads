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
						@rest
						.one 'campaigns', @subscription.campaign
						.get()
						.then (@campaign) =>
								@rest
								.one 'programs', @campaign.program
								.get()
								.then (@program) =>



		SubscriptionCreateCtrl.$inject = ["Restangular", "$location"]
		app.controller 'SubscriptionCreateCtrl', SubscriptionCreateCtrl