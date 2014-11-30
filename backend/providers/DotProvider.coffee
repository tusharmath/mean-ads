dot = require 'dot'
class DotProvider
	constructor: ->
		dot.templateSettings.strip = true
	template: (html) ->
		dot.template html

module.exports = DotProvider