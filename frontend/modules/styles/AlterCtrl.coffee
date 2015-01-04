app = require '../../app'
_ = require 'lodash'

	class StyleAlterCtrl
		constructor: (@rest, @interpolate, @alter, @tok) ->
			@alter.bootstrap @, 'style'

		# TODO: Move to a service
		_getStyleTags: -> "<style>#{@style.css}</style>"

		beforeSave: () ->
			@style.placeholders = @tok.tokenize @style.placeholders

	StyleAlterCtrl.$inject = [
		'Restangular'
		'$interpolate'
		'AlterControllerExtensionService'
		'TokenizerService'
		]
	app.controller 'StyleAlterCtrl', StyleAlterCtrl
