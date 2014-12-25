class HttpProvider
	constructor: ->
		@http = require 'http'
	get: (args...)->
		@http.get args...
module.exports = HttpProvider