define ["app"], (app) ->
	class ProfileListCtrl
		constructor: (profilePromise) ->
			profilePromise.then (@profile) =>

	ProfileListCtrl.$inject = ['Profile']

	app.controller 'ProfileListCtrl', ProfileListCtrl
