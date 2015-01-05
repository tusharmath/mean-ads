app = angular.module 'mean-ads', [
	'ngRoute'
	'restangular'
	'mean.core'
	'auth0'
	'angular-jwt'
	'angular-storage'
]
.run ['auth', (auth) ->
		auth.hookEvents()
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
			loginUrl: '/login'
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
		_routeResolver 'Login'
		_routeResolver 'Program', ['Create', 'Update', 'List', 'Snippet']
		_routeResolver 'Campaign', ['Create', 'Update', 'List', 'Metrics']
		_routeResolver 'Subscription', ['Create', 'Update', 'List', 'Metrics']
		_routeResolver 'Style', ['Create', 'Update', 'List']


		$routeProvider.otherwise redirectTo: '/subscriptions'
		$locationProvider.html5Mode false
]
module.exports = app