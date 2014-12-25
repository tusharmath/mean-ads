querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../providers/HttpProvider'
HostNameBuilder = require './HostNameBuilder'
CommandExecutor = require './CommandExecutor'
class ConvertCommand
	constructor: (@http, @host, @exec) ->
		@exec.register @
	alias: 'convert'
	_getUrl: (id) ->
		@host.getHostWithProtocol() + "/api/v1/subscription/#{id}/convert"
	callback: ->
	execute: (subscriptionId) ->
		return null if not subscriptionId
		url = @_getUrl subscriptionId
		@http.get url, {withCredentials: true}, @callback


annotate ConvertCommand, new Inject HttpProvider, HostNameBuilder, CommandExecutor
module.exports = ConvertCommand