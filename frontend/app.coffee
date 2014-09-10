define [
	'angular'
	'lib/angular-route'
	'lib/ui-ace'
	'Restangular'
], (angular) ->
	'use strict'

	angular.module 'mean-ads', [
		'ngRoute'
		'restangular'
		'ui.ace'
		'route.resolver'
	]
	.config [
		'$routeProvider'
		'$locationProvider'
		'$httpProvider'
		'RestangularProvider'
		'RouteResolverProvider'
		(args...) ->
			[
				$routeProvider
				$locationProvider
				$httpProvider
				restProvider
				routeResolver
			] = args

			restProvider.setBaseUrl '/api/v1'
			restProvider.setDefaultHttpFields cache: true
			restProvider.setRestangularFields id: '_id'

			# TODO: Too verbose
			console.log routeResolver.resolve 'Campaign'
			$routeProvider
				.when '/dashboard',
					templateUrl: 'modules/dashboard/dashboard'
					controller: 'DashboardCtrl as dashCtrl'

				# Programs
				.when '/programs',
					templateUrl: 'modules/programs/program'
					controller: 'ProgramCtrl as prgCtrl'
				.when '/programs/create',
					templateUrl: 'modules/programs/create'
					controller: 'ProgramCreateCtrl as ctrl'

				#Campaigns
				.when '/campaigns',
					templateUrl: 'modules/campaigns/campaign'
					controller: 'CampaignCtrl as cmpCtrl'
				.when '/campaigns/create',
					templateUrl: 'modules/campaigns/create'
					controller: 'CampaignCreateCtrl as ctrl'

				#Subscriptions
				.when '/subscriptions',
					templateUrl: 'modules/subscriptions/subscription'
					controller: 'SubscriptionCtrl as subCtrl'
				.when '/subscriptions/create',
					templateUrl: 'modules/subscriptions/create'
					controller: 'SubscriptionCreateCtrl as subCtrl'

				#Keywords
				.when '/keywords',
					templateUrl: 'modules/keywords/keyword'
					controller: 'KeywordCtrl as kwCtrl'

				#Styles
				.when '/styles',
					templateUrl: 'modules/styles/style'
					controller: 'StyleCtrl as stylCtrl'
				.when '/styles/create',
						templateUrl: 'modules/styles/create'
						controller: 'StyleCreateCtrl as ctrl'
				.when '/styles/:id',
						templateUrl: 'modules/styles/create'
						controller: 'StyleCreateCtrl as ctrl'

				.otherwise redirectTo: '/dashboard'
			$locationProvider.html5Mode false
	]
