define ["app"], (app) ->
	class SubscriptionMetricsCtrl
		constructor: (@rest, @route) ->
			@rest.one 'subscriptions', @route.id
			.get()
			.then @onSubscription
		onSubscription: (@subscription) =>
			elapsedTime_ms = new Date() - new Date @subscription.startDate
			@elapsedTime_days = Math.floor elapsedTime_ms / (24 * 3600 * 1000)
			@rest.one 'campaigns', @subscription.campaign
			.get()
			.then @onCampaign
		onCampaign: (@campaign) =>
			@creditAnticipation = @campaign.commitment / @campaign.days * @elapsedTime_days
			@creditPotentialUsage = Math.round( @subscription.usedCredits / @elapsedTime_days * @campaign.days)
			@fulfillment = Math.round (@creditPotentialUsage / @creditAnticipation * 100)
			@rest.one 'programs', @campaign.program
			.get()
			.then (@program) =>


	SubscriptionMetricsCtrl.$inject = ['Restangular', '$routeParams']
	app.controller 'SubscriptionMetricsCtrl', SubscriptionMetricsCtrl
