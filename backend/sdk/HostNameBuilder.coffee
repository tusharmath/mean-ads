WindowProvider = require '../providers/WindowProvider'
Url = require 'url'
{annotate, Inject} = require 'di'
class HostNameBuilder
	constructor: (@windowP) ->
		@_hostCache=null
	getHost: ->
		return @_hostCache if @_hostCache
		{g} = @windowP.window().ma
		if g
			{host} = Url.parse g
			@_hostCache = "#{host}"
		else
			@_hostCache = 'app.meanads.com'
		@_hostCache

annotate HostNameBuilder, new Inject WindowProvider
module.exports = HostNameBuilder