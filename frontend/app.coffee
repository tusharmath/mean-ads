define [
	'angular'
	'lodash'
	'auth0-widget'
	'lib/angular-route'
	'lib/ui-ace'
	'Restangular'
], (angular, _, Auth0Widget) ->
	'use strict'

	angular
	.module 'mean-ads', ['ngRoute', 'restangular', 'ui.ace', 'mean.core', 'auth0']
	.run ['auth', (auth) -> auth.hookEvents() ]
	.config [
		'$routeProvider'
		'$locationProvider'
		'$httpProvider'
		'RestangularProvider'
		'RouteResolverProvider'
		'authProvider'
		'ProfileProvider'
		(args...) ->
			[
				$routeProvider
				$locationProvider
				$httpProvider
				restProvider
				routeResolver
				authProvider
				profileProvider
			] = args
			authProvider.init
				domain: 'mean-ads.auth0.com'
				clientID: '6zvBZ3dG9XJl8zre9bCpPNTTxozUShX7'
				loginUrl: '/login'
				Auth0Widget
			authProvider.on 'loginSuccess', profileProvider.onLoginSuccess
			$httpProvider.interceptors.push 'authInterceptor'

			restProvider.setBaseUrl '/api/v1/core'
			restProvider.setDefaultHttpFields cache: false
			restProvider.setRestangularFields id: '_id'

			_routeResolver = _.curry(routeResolver.resolve, 2) $routeProvider
			#TODO: Read all controllers and their actions and create this
			_routeResolver 'Dashboard'
			_routeResolver 'Login'
			_routeResolver 'Program', ['Create', 'Update', 'List', 'Snippet']
			_routeResolver 'Campaign', ['Create', 'Update', 'List', 'Metrics']
			_routeResolver 'Subscription', ['Create', 'Update', 'List', 'Metrics']
			_routeResolver 'Style', ['Create', 'Update', 'List']


			$routeProvider.otherwise redirectTo: '/subscriptions'
			$locationProvider.html5Mode false
	]
