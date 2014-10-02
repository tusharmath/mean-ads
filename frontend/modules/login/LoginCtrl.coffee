define ["app"], (app) ->
	class LoginCtrl
		constructor: (@auth, @location) ->
			return @onSuccess() if @auth.isAuthenticated is yes
			@auth.signin {popup: true} , @onSuccess, @onFailure
		onSuccess: => @location.path '/dashbords'
	LoginCtrl.$inject = ['auth', '$location']
	app.controller 'LoginCtrl', LoginCtrl
