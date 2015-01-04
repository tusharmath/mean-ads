app = require '../../app'
class ProfileListCtrl
	constructor: (profilePromise) ->
		profilePromise.then (@profile) =>
			# TODO: Must move to a service
			@profile.picture=@profile.picture.replace 's=480', 's=64'

ProfileListCtrl.$inject = ['Profile']

app.controller 'ProfileListCtrl', ProfileListCtrl
