define ["app"], (app) ->
	class ProgramAlterCtrl
		constructor: (@rest, @route, @alter) ->
			rest.one('programs', @route.id).get().then (@program) =>
				@program.style = @program.style._id
			rest.all('styles').getList().then (@styles) =>
		save: () ->
			@alter.persist 'programs', @program

	ProgramAlterCtrl.$inject = [
		"Restangular", "$routeParams", 'AlterPersistenceService'
	]
	app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
