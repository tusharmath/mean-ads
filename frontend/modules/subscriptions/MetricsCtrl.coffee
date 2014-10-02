define ["app"], (app) ->
	class SubscriptionMetricsCtrl
		constructor: (@rest, @route, $q) ->
			@rest.one('subscriptions', @route.id).get()
			.then (@subscription) => @rest.one('campaigns', @subscription.campaign).get()
			.then (@campaign) => @rest.one('programs', @campaign.program).get()
			.then (@program) =>
				elapsedTime_ms = new Date() - new Date @subscription.startDate
				@elapsedTime_days = Math.floor elapsedTime_ms / (24 * 3600 * 1000)
				@isInActive = @subscription.totalCredits is @subscription.usedCredits
				@creditAnticipation = @subscription.totalCredits / @campaign.days * @elapsedTime_days
				@creditPotentialUsage = @subscription.usedCredits / @elapsedTime_days * @campaign.days
				@fulfillment = @creditPotentialUsage / @creditAnticipation * 100
				@isExpired = @elapsedTime_days is @campaign.days

	SubscriptionMetricsCtrl.$inject = ['Restangular', '$routeParams', '$q']
	app.controller 'SubscriptionMetricsCtrl', SubscriptionMetricsCtrl
