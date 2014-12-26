jade = require 'jade'
class JadeProvider
	constructor: ->
		@options = {}
	compileFile: (source) ->
		jade.compileFile source, @options
module.exports = JadeProvider