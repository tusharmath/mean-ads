define ["app"], (app) ->
	class SubscriptionMetricsCtrl
		constructor: (@rest, @route) ->
			@rest.one 'subscriptions', @route.id
			.get()
			.then @onSubscription
		onSubscription: (@subscription) =>
			elapsedTime_ms = new Date() - new Date @subscription.startDate
			@elapsedTime_days = Math.floor elapsedTime_ms / (24 * 3600 * 1000)
			@isInActive = @subscription.totalCredits is @subscription.usedCredits

			@rest.one 'campaigns', @subscription.campaign
			.get()
			.then @onCampaign
		onCampaign: (@campaign) =>

			@creditAnticipation = @subscription.totalCredits / @campaign.days * @elapsedTime_days
			@creditPotentialUsage = @subscription.usedCredits / @elapsedTime_days * @campaign.days
			@fulfillment = @creditPotentialUsage / @creditAnticipation * 100
			@isExpired = @elapsedTime_days is @campaign.days
			@rest.one 'programs', @campaign.program
			.get()
			.then (@program) =>


	SubscriptionMetricsCtrl.$inject = ['Restangular', '$routeParams']
	app.controller 'SubscriptionMetricsCtrl', SubscriptionMetricsCtrl
