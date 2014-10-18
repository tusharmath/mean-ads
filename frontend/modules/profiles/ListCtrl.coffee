define ["app"], (app) ->
	class ProfileListCtrl
		constructor: (auth) ->
			auth.profilePromise.then (@profile) =>
				@profile.picture = @profile.picture.replace /s=480/, 's=50'

	ProfileListCtrl.$inject = ['auth']

	app.controller 'ProfileListCtrl', ProfileListCtrl
