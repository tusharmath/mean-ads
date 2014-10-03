define ["app"], (app) ->
	class CampaignMetricsCtrl
		constructor: (@rest, @route, $q) ->
			@rest
			.all('subscriptions')
			.one('count')
			.get(campaign: @route.id).then (count) => @subscriptionCount = count.count

			@rest.one('campaigns', @route.id).get()
			.then (@campaign) =>				@rest.one('programs', @campaign.program).get()
			.then (@program) =>
				@avgCommitment = Math.round @campaign.commitment / @campaign.days
				@rest
				.one('campaigns', @route.id)
				.one('credits')
				.get().then (credits) =>
					{@creditDistribution, @creditUsage} = credits
					@creditDistribution = Math.round @creditDistribution / @campaign.days
					@creditUsage = Math.round @creditUsage / @campaign.days
					@fulfillment = 100 * @creditDistribution / @avgCommitment

	CampaignMetricsCtrl.$inject = ['Restangular', '$routeParams', '$q']
	app.controller 'CampaignMetricsCtrl', CampaignMetricsCtrl
