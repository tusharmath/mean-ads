define ['angular', 'lodash','lib/angular-route','lib/ui-ace','Restangular'], (angular, _) ->
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
			restProvider.setDefaultHttpFields cache: false
			restProvider.setRestangularFields id: '_id'

			_routeResolver = _.curry(routeResolver.resolve, 2) $routeProvider

			#TODO: Should be dynamic based on the controller
			_routeResolver 'Dashboard'
			_routeResolver 'Program', ['Create', 'Update', 'List']
			_routeResolver 'Campaign', ['Create', 'Update', 'List']
			_routeResolver 'Subscription', ['Create', 'Update', 'List']
			_routeResolver 'Style', ['Create', 'Update', 'List']

			$routeProvider.otherwise redirectTo: '/dashboards'

			$locationProvider.html5Mode false
	]
