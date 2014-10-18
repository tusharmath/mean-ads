define ['angular'], (angular)->
	class ProfileProvider
		constructor: ->
			@defer = null
			@auth = 0
			@me = 100
			@$get = ['auth', '$q', @get]

		onLoginSuccess: =>
			console.log 'Now logging'
			@defer.resolve @auth.profilePromise
		get: (@auth, Q) =>
			console.log @me
			if auth.isAuthenticated is yes
				console.log 'Authenticated - yes'
				return auth.profilePromise
			console.log 'Authenticated - No'
			@defer = Q.defer()
			@defer.promise




	angular.module 'profile', ['auth0']
	.provider 'Profile', ProfileProvider