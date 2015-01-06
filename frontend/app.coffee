app = angular.module 'mean-ads', [
	'ngRoute'
	'restangular'
	'mean.core'
	'auth0'
	'angular-jwt'
	'angular-storage'
]
.run ['auth', '$rootScope', '$location', (auth, $rootScope, $location) ->
		auth.hookEvents()
		$rootScope.$on 'unauthenticated', ->
			$location.path '/login'
	]
.config [
	'$routeProvider'
	'$locationProvider'
	'$httpProvider'
	'RestangularProvider'
	'RouteResolverProvider'
	'authProvider'
	'ProfileProvider'
	'jwtInterceptorProvider'
	(args...) ->
		[
			$routeProvider
			$locationProvider
			$httpProvider
			restProvider
			routeResolver
			authProvider
			profileProvider
			jwtInterceptorProvider
		] = args
		authProvider.init
			domain: 'mean-ads.auth0.com'
			clientID: '6zvBZ3dG9XJl8zre9bCpPNTTxozUShX7'
		authProvider.on 'loginSuccess', profileProvider.onLoginSuccess
		$httpProvider.interceptors.push 'AjaxPendingRequests'
		$httpProvider.interceptors.push 'jwtInterceptor'
		jwtInterceptorProvider.tokenGetter = ['store', (store) -> store.get 'token']

		restProvider.setBaseUrl '/api/v1/core'
		restProvider.setDefaultHttpFields cache: false
		restProvider.setRestangularFields id: '_id'

		_routeResolver = _.curry(routeResolver.resolve, 2) $routeProvider
		#TODO: Read all controllers and their actions and create this
		_routeResolver 'Dashboard'
		_routeResolver 'Login', requiresLogin: false
		_routeResolver 'Program', actions: ['Create', 'Update', 'List', 'Snippet']
		_routeResolver 'Campaign', actions: ['Create', 'Update', 'List', 'Metrics']
		_routeResolver 'Subscription', actions: ['Create', 'Update', 'List', 'Metrics']
		_routeResolver 'Style', actions: ['Create', 'Update', 'List']


		$routeProvider.otherwise redirectTo: '/subscriptions'
		$locationProvider.html5Mode false
]
module.exports = app