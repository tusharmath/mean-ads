define ["app"], (app) ->
	class ProgramAlterCtrl
		constructor: (@rest, @route, @alter) ->
			if @route.id
				rest.one('programs', @route.id).get().then (@program) =>
			rest.all('styles').getList().then (@styles) =>
		save: () ->
			@alter.persist 'programs', @program

	ProgramAlterCtrl.$inject = [
		"Restangular", "$routeParams", 'AlterPersistenceService'
	]
	app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
