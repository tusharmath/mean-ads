app = require '../../app'

class ProfileListCtrl
	constructor: (auth, scope, profile) ->
		profile.getProfileQ().then (@profile) =>
			@profile.picture = @_reducePicture @profile.picture
	_reducePicture: (picture)->
		picture.replace 's=480', "s=64"

ProfileListCtrl.$inject = ['auth', '$scope', 'ProfileService']

app.controller 'ProfileListCtrl', ProfileListCtrl
