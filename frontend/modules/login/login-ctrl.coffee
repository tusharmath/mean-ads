define ["app"], (app) ->
	class LoginCtrl
		constructor: (@auth) ->
			@auth.signin {popup: true} , @onSuccess, @onFailure
		onSuccess: ->
		onFailure: ->
	LoginCtrl.$inject = ['auth']
	app.controller 'LoginCtrl', LoginCtrl
