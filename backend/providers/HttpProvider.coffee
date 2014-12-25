class HttpProvider
	constructor: ->
		@http = require 'request'
	get: (args...)->
		@http args...
module.exports = HttpProvider