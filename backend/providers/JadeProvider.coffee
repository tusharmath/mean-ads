jade = require 'jade'
class JadeProvider
	constructor: ->
		@options = {}
	renderFile: (source) -> jade.renderFile source, @options
module.exports = JadeProvider