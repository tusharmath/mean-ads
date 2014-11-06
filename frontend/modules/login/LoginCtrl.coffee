define ["app"], (app) ->
	class LoginCtrl
		constructor: (@auth, @location) ->
			if @auth.isAuthenticated is yes and @auth.hasTokenExpired() is no
				return @onSuccess()
			@auth.signin {popup: true} , @onSuccess, @onFailure
		onSuccess: => @location.path '/dashbords'
	LoginCtrl.$inject = ['auth', '$location']
	app.controller 'LoginCtrl', LoginCtrl
