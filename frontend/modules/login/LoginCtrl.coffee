define ["app"], (app) ->
	class LoginCtrl
		constructor: (@auth, @location) ->
			if @auth.isAuthenticated is yes
				return @onSuccess()
			@auth.signin {popup: true} , @onSuccess, @onFailure
		onSuccess: => @location.path '/'
	LoginCtrl.$inject = ['auth', '$location']
	app.controller 'LoginCtrl', LoginCtrl
