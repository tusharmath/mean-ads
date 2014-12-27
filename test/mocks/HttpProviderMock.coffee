HttpProvider = require '../../backend/sdk/HttpProvider'
{annotate, Provide} = require 'di'
class HttpProviderMock
	get: (url,options, @callback) ->
	$flush: (args...) ->
		throw Error 'Set the callback dude!' if not @callback
		@callback args...

annotate HttpProviderMock, new Provide HttpProvider
module.exports = HttpProviderMock