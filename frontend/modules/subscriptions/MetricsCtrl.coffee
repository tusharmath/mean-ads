app = require '../../app'

class SubscriptionMetricsCtrl
	constructor: (@rest, @route, $q) ->
		@rest.one('subscription', @route.id).get()
		.then (@subscription) => @rest.one('campaign', @subscription.campaign).get()
		.then (@campaign) => @rest.one('program', @campaign.program).get()
		.then (@program) =>
			elapsedTime_ms = new Date() - new Date @subscription.startDate
			@elapsedTime_days = Math.floor elapsedTime_ms / (24 * 3600 * 1000)
			@isInActive = @subscription.totalCredits is @subscription.usedCredits
			@creditAnticipation = @subscription.totalCredits / @campaign.days * @elapsedTime_days
			@creditPotentialUsage = @subscription.usedCredits / @elapsedTime_days * @campaign.days
			@fulfillment = @creditPotentialUsage / @subscription.totalCredits
			@isExpired = @elapsedTime_days >= @campaign.days
	sendEmail: =>
		@rest.one 'subscription', @route.id
		.post 'email'
SubscriptionMetricsCtrl.$inject = ['Restangular', '$routeParams', '$q']
app.controller 'SubscriptionMetricsCtrl', SubscriptionMetricsCtrl
