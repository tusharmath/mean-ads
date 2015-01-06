app = require '../../app'
class ProfileListCtrl
	constructor: (@store) ->
		@profile = @store.get 'profile'
		@profile.picture = @profile.picture.replace 's=480', 's=64'


ProfileListCtrl.$inject = ['store']

app.controller 'ProfileListCtrl', ProfileListCtrl
