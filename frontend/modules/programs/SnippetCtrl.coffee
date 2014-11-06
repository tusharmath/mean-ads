define ['app'], (app) ->
	class SnippetCtrl
		constructor: (@rest, @route) ->
			@rest.one('program', @route.id).get()
			.then (@program) =>

	SnippetCtrl.$inject = ['Restangular', '$routeParams']
	app.controller 'ProgramSnippetCtrl', SnippetCtrl