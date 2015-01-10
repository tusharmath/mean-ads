app = require './app'
class ProfileService
	constructor: (@auth, @Q, @store, rootScope) ->

	getProfileQ: ->
		profile = @store.get 'profile'
		if profile then return @Q -> profile
		token = @store.get 'token'
		return rootscope.$broadcast 'unauthenticated' if not token
		@auth.getProfile token
		.then (profile) =>
			@store.set 'profile', profile
			ProfileService


ProfileService.$inject = ['auth', '$q', 'store', '$rootScope']

app.service 'ProfileService', ProfileService