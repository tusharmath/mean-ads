querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../providers/HttpProvider'
HostNameBuilder = require './HostNameBuilder'
CommandExecutor = require './CommandExecutor'
class AdCommand
	constructor: (@http, @host, @exec) ->
		@exec.register @
	_baseUrl: '/api/v1/dispatch/ad?'
	alias: 'ad'
	_getUrl: (p, k) ->
		req = {p}
		req.k = k if k
		@host.getHostWithProtocol() + @_baseUrl + querystring.stringify req
	execute: (program, element, keywords) ->
		return null if not program or not element
		url = @_getUrl program, keywords
		@http.get url, (response) -> element.innerHTML = response


annotate AdCommand, new Inject HttpProvider, HostNameBuilder, CommandExecutor
module.exports = AdCommand