define ["app"], (app) ->
	class ProfileListCtrl
		constructor: (profilePromise) ->
			profilePromise.then (@profile) =>
				@profile.picture = @profile.picture.replace /s=480/, 's=50'

	ProfileListCtrl.$inject = ['Profile']

	app.controller 'ProfileListCtrl', ProfileListCtrl
