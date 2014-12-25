querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../providers/HttpProvider'
HostNameBuilder = require './HostNameBuilder'
class ConvertCommand
	constructor: (@http, @host) ->
	_getUrl: (id) ->
		"//" + @host.getHost() + "/api/v1/subscription/#{id}/convert"
	callback: ->
	execute: (subscriptionId) ->
		return null if not subscriptionId
		url = @_getUrl subscriptionId
		@http.get url, @callback


annotate ConvertCommand, new Inject HttpProvider, HostNameBuilder
module.exports = ConvertCommand