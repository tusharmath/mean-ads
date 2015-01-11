HtmlMinifier = require 'html-minifier'
config = require '../config/config'
class HtmlMinifierProvider
	constructor: ->
	minify: (html) ->
		HtmlMinifier.minify html, config.htmlMinify

module.exports = HtmlMinifierProvider