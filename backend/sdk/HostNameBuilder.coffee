WindowProvider = require '../providers/WindowProvider'
Url = require 'url'
{annotate, Inject} = require 'di'
class HostNameBuilder
	constructor: (@windowP) ->
		@_hostCache=null
	setup: ->
		return @_hostCache if @_hostCache
		{g, location} = @windowP.window().ma
		if g
			{host} = Url.parse "http:#{g}"
			@_hostCache = "#{host}"
		else
			@_hostCache = 'app.meanads.com'
		@_hostCache
	getHost: ->
	getHostWithProtocol: ->
		throw new Error 'setup the HostNameBuilder first dude!' if not @_hostCache
		"#{@windowP.window().location.protocol}//#{@_hostCache}"

annotate HostNameBuilder, new Inject WindowProvider
module.exports = HostNameBuilder