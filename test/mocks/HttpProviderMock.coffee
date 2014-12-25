HttpProvider = require '../../backend/providers/HttpProvider'
{annotate, Provide} = require 'di'
class HttpProviderMock
	get: (@url, @callback) ->
	$flush: (data) ->
		throw Error 'Set the callback dude!' if not @callback
		@callback data

annotate HttpProviderMock, new Provide HttpProvider
module.exports = HttpProviderMock