define ['app'], (app) ->
	class SnippetCtrl
		constructor: (@rest, @route, @window) ->
			@host = @window.location.host
			@rest.one('program', @route.id).get()
			.then (@program) =>

	SnippetCtrl.$inject = ['Restangular', '$routeParams', '$window']
	app.controller 'ProgramSnippetCtrl', SnippetCtrl