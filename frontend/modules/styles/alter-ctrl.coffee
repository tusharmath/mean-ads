define ["app", "lodash"], (app, _) ->
	class StyleAlterCtrl
		constructor: (@rest, @interpolate, @alter) ->
			@alter.bootstrap @, 'style'

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


	StyleAlterCtrl.$inject = [
		'Restangular'
		'$interpolate'
		'AlterControllerExtensionService'
		]
	app.controller 'StyleAlterCtrl', StyleAlterCtrl
