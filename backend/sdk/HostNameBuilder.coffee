WindowProvider = require '../providers/WindowProvider'
{annotate, Inject} = require 'di'
class HostNameBuilder
	constructor: (@windowP) ->
	getHost: ->
		window = windowP.window()

annotate HostNameBuilder, new Inject WindowProvider
module.exports = HostNameBuilder