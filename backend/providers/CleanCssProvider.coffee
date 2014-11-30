CleanCss = require 'clean-css'
class CleanCssProvider
	constructor: ->
		@cssMin = new CleanCss
	minify: (css) -> @cssMin.minify css

module.exports = CleanCssProvider