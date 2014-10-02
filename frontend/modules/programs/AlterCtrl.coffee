define ["app"], (app) ->
	class ProgramAlterCtrl
		constructor: (@rest, @alter) ->
			@alter.bootstrap @, 'program'
			rest.all('styles').getList().then (@styles) =>

	ProgramAlterCtrl.$inject = [
		"Restangular", 'AlterControllerExtensionService'
	]
	app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
