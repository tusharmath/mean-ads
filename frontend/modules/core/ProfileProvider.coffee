define ['modules/core/app'], (app)->
	class ProfileProvider
		constructor: ->
			@defer = null
			@auth = 0
			@$get = ['auth', '$q', @get]

		onLoginSuccess: =>
			@defer.resolve @auth.profilePromise
		get: (@auth, Q) =>
			if @auth.hasTokenExpired() is no and @auth.isAuthenticated is yes
				return @auth.profilePromise
			@defer = Q.defer()
			@defer.promise

	app.provider 'Profile', ProfileProvider