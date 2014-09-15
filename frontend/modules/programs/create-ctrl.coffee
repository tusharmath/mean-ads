define ["app"], (app) ->
		class ProgramCreateCtrl
				constructor: (@rest, @loc) ->
						@program = {}
						rest.all('styles').getList().then (@styles) =>
				save: () ->
						@rest
						.all 'programs'
						.post @program
						.then () =>
								@loc.path '/programs'

		ProgramCreateCtrl.$inject = ["Restangular", "$location"]
		app.controller 'ProgramCreateCtrl', ProgramCreateCtrl
