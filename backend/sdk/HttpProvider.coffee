class HttpProvider
	constructor: ->
		@ajax = require 'component-ajax'
	get: (url, xhrFields, success)->
		@ajax(
			{url}
			{xhrFields}
			{success}
			)
module.exports = HttpProvider