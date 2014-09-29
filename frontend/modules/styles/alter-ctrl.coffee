define ["app", "lodash"], (app, _) ->
	class StyleAlterCtrl
		constructor: (@rest, @interpolate, @alter, @tok) ->
			@alter.bootstrap @, 'style'

		# TODO: Move to a service
		_getStyleTags: -> "<style>#{@style.css}</style>"

		beforeSave: () ->
			@style.placeholders = @tok.tokenize @style.placeholders

		preview: ->
			template = @interpolate @style.html
			data = @tok.tokenize @style.placeholders
			context = {}
			_.each data, (key) -> context[key] = key
			@interpolation = @_getStyleTags() + template context


	StyleAlterCtrl.$inject = [
		'Restangular'
		'$interpolate'
		'AlterControllerExtensionService'
		'TokenizerService'
		]
	app.controller 'StyleAlterCtrl', StyleAlterCtrl
