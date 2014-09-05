define ["app", "lodash"], (app, _) ->
	class StyleCreateCtrl
		constructor: (@rest, @loc) ->
			@style = {}

		onContentChange: ->

		save: () ->
			@style.placeholders = _.compact @style.placeholders.split /[\s,.|]/
			@rest
			.all 'styles'
			.post @style
			.then () =>
				@loc.path '/styles'

	StyleCreateCtrl.$inject = ["Restangular", "$location"]
	app.controller 'StyleCreateCtrl', StyleCreateCtrl
