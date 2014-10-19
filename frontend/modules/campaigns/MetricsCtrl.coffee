define ["app"], (app) ->
	class CampaignMetricsCtrl
		constructor: (@rest, @route, $q) ->
			rSubscriptions = @rest.all('subscriptions')
			$q.all [
				rSubscriptions.one('count').get(campaign: @route.id)
				rSubscriptions.one('credits').get(campaign: @route.id)
				@rest.one('campaigns', @route.id).get()
			]
			.then (args) =>
				[count, @credits, @campaign] = args
				@subscriptionCount = count.count
			.then => @rest.one('programs', @campaign.program).get()
			.then (@program) =>
				{@creditDistribution, @creditUsage} = @credits
				@avgCommitment = Math.round @campaign.commitment / @campaign.days
				@creditDistribution = Math.round @creditDistribution / @campaign.days
				@creditUsage = Math.round @creditUsage / @campaign.days
				@fulfillment = 100 * @creditDistribution / @avgCommitment
				console.log @

	CampaignMetricsCtrl.$inject = ['Restangular', '$routeParams', '$q']
	app.controller 'CampaignMetricsCtrl', CampaignMetricsCtrl
