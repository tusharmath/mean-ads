define ["app", "lodash"], (app, _) ->
	class StyleAlterCtrl
		constructor: (@rest, @interpolate, @route, @alter) ->
			if @route.id
				@rest
				.one 'styles', @route.id
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
			@alter.persist 'styles', @style

	StyleAlterCtrl.$inject = [
		'Restangular'
		'$interpolate'
		'$routeParams'
		'AlterPersistenceService'
		]
	app.controller 'StyleAlterCtrl', StyleAlterCtrl
