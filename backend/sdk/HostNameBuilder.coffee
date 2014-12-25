WindowProvider = require '../providers/WindowProvider'
Url = require 'url'
{annotate, Inject} = require 'di'
class HostNameBuilder
	constructor: (@windowP) ->
	getHost: ->
		{g} = @windowP.window().ma
		if g
			{host} = Url.parse g
			"#{host}"
		else
			'app.meanads.com'

annotate HostNameBuilder, new Inject WindowProvider
module.exports = HostNameBuilder