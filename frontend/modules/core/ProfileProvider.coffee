define ['modules/core/app'], (app)->
	class ProfileProvider
		constructor: ->
			@defer = null
			@auth = 0
			@$get = ['auth', '$q', @get]

		_getProfileQ: ->
			@auth.getProfile @auth.idToken

		onLoginSuccess: =>
			@defer.resolve @_getProfileQ()
		get: (@auth, Q) =>
			if @auth.isAuthenticated is no
				@defer = Q.defer()
				return @defer.promise
			else
				return @_getProfileQ()

	app.provider 'Profile', ProfileProvider