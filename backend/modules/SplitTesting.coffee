{annotate, Inject} = require 'di'

class SplitTesting
	constructor: (@requireP, @utils) ->
	_baseExprPath: '../experiments/'
	_load: (module) ->
		path = "#{@_baseExprPath + @utils.snakeCaseToCamelCase module}Expr"
		@requireP.require path

annotate SplitTesting, new Inject(
	require '../providers/RequireProvider'
	require '../Utils'
	require '../providers/AbTestingProvider'
	)
module.exports = SplitTesting