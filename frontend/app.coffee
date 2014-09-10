define ['angular','lib/angular-route','lib/ui-ace','Restangular'], (angular) ->
	'use strict'
	angular.module 'mean-ads', ['ngRoute', 'restangular', 'ui.ace', 'route.resolver']
	.config [
		'$routeProvider',	'$locationProvider', '$httpProvider'
		'RestangularProvider', 'RouteResolverProvider'
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
			$routeProvider
				.when '/dashboard', routeResolver.resolve 'Dashboard'
				.when '/programs', routeResolver.resolve 'Program'
				.when '/programs/create', routeResolver.resolve 'Program', 'Create'

				#Campaigns
				.when '/campaigns', routeResolver.resolve 'Campaign'
				.when '/campaigns/create', routeResolver.resolve 'Campaign', 'Create'

				#Subscriptions
				.when '/subscriptions', routeResolver.resolve 'Subscription'
				.when '/subscriptions/create', routeResolver.resolve 'Subscription', 'Create'


				#Styles
				.when '/styles', routeResolver.resolve 'Style'
				.when '/styles/create', routeResolver.resolve 'Style', 'Create'
				.when '/styles/:id', routeResolver.resolve 'Style', 'Update'

				.otherwise redirectTo: '/dashboard'
			$locationProvider.html5Mode false
	]
