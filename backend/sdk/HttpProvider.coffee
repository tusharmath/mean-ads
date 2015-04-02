{ClassProvider, annotate} = require 'di'
class HttpProvider
	constructor: ->
		@ajax = require 'component-ajax'
	get: (url, xhrFields, success)->
		@ajax {url ,xhrFields ,success}
annotate HttpProvider, new ClassProvider
module.exports = HttpProvider