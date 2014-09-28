define ["app", "lodash"], (app, _) ->
	class StyleAlterCtrl
		constructor: (@rest, @loc, @interpolate, @route) ->
			@rest.one 'styles', @route.id
			.get()
			.then (@style) =>

		# TODO: Move to a service
		getPlaceholders: ->
			if @style.placeholders
				if typeof @style.placeholders is 'string'
					_.compact @style.placeholders.split /[\s,.|]/
				else
					@style.placeholders
			else
				[]
		# TODO: Move to a service
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
			.one 'styles', @style._id
			.patch @style
			.then () =>
				@loc.path '/styles'

	StyleAlterCtrl.$inject = ["Restangular", "$location", "$interpolate", "$routeParams"]
	app.controller 'StyleAlterCtrl', StyleAlterCtrl
