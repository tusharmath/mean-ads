define ["app"], (app) ->
	class ProgramUpdateCtrl
		constructor: (@rest, @loc, @route) ->
			rest.one('programs', @route.id).get().then (@program) =>
					@program.style = @program.style._id
			rest.all('styles').getList().then (@styles) =>
		save: () ->
			@rest
			.one 'programs', @program._id
			.patch @program
			.then () =>
				@loc.path '/programs'

	ProgramUpdateCtrl.$inject = ["Restangular", "$location", "$routeParams"]
	app.controller 'ProgramUpdateCtrl', ProgramUpdateCtrl
