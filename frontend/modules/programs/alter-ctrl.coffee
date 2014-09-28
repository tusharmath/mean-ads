define ["app"], (app) ->
	class ProgramAlterCtrl
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

	ProgramAlterCtrl.$inject = ["Restangular", "$location", "$routeParams"]
	app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
