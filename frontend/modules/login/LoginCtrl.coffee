app = require '../../app'
class LoginCtrl
	constructor: (@auth, @location, @store) ->
		if @auth.isAuthenticated is yes
			return @onSuccess()
		@auth.signin {} , @onSuccess
	onSuccess: (profile, token) =>
		@store.set 'profile', profile
		@store.set 'token', token
		@location.path '/'
	onError: (err)-> throw err
LoginCtrl.$inject = ['auth', '$location', 'store']
app.controller 'LoginCtrl', LoginCtrl
