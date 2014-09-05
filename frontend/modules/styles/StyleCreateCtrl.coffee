define ["app", "lodash"], (app, _) ->
	class StyleCreateCtrl
		constructor: (@rest, @loc, @interpolate) ->
			@style = {}

		getPlaceholders: ->
			if @style.placeholders
				_.compact @style.placeholders.split /[\s,.|]/
			else
				[]
		getStyleTags: -> "<style>#{@style.css}</style>"
		preview: ->
			template = @interpolate @style.html
			data = @getPlaceholders()
			context = {}
			_.each data, (key) -> context[key] = key
			@interpolation = @getStyleTags() + template context

		save: () ->
			@style.placeholders = @getPlaceholders()
			@rest
			.all 'styles'
			.post @style
			.then () =>
				@loc.path '/styles'

	StyleCreateCtrl.$inject = ["Restangular", "$location", "$interpolate"]
	app.controller 'StyleCreateCtrl', StyleCreateCtrl
