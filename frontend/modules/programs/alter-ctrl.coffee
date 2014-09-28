define ["app"], (app) ->
	class ProgramAlterCtrl
		constructor: (@rest, @route, @alter) ->
			@program = @first.load 'programs'
			rest.all('styles').getList().then (@styles) =>
		save: () ->
			@alter.persist 'programs', @program

	ProgramAlterCtrl.$inject = [
		"Restangular", "$routeParams", 'AlterPersistenceService'
	]
	app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
