define ["app"], (app) ->
	class ProgramCtrl
		constructor: (rest) ->
			rest.all('programs').getList(populate: ['style'] ).then (@programs) =>

	ProgramCtrl.$inject = ["Restangular"]
	app.controller 'ProgramListCtrl', ProgramCtrl
