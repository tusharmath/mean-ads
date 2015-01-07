app = require './app'
class ProfileService
	constructor: (@auth, @Q, @store, rootScope) ->

	getProfileQ: ->
		profile = @store.get 'profile'
		if profile then return Q -> profile
		token = @store.get 'token'
		if token then return @auth.getProfile token
		rootscope.$broadcast 'unauthenticated'

ProfileService.$inject = ['auth', '$q', 'store', '$rootScope']

app.service 'ProfileService', ProfileService