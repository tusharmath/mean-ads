app = require '../../app'
class ProgramAlterCtrl
	constructor: (@rest, @alter, @tok) ->
		@alter.bootstrap @, 'program'
		@rest.all('styles').getList().then (@styles) =>
	beforeSave: ->
		@program.allowedOrigins = @tok.tokenize @program.allowedOrigins

ProgramAlterCtrl.$inject = [
	"Restangular", 'AlterControllerExtensionService', 'TokenizerService'
]
app.controller 'ProgramAlterCtrl', ProgramAlterCtrl
