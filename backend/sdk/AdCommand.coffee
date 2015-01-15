querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../sdk/HttpProvider'
HostNameBuilder = require './HostNameBuilder'
CommandExecutor = require './CommandExecutor'
class AdCommand
	constructor: (@http, @host, @exec) ->
		@exec.register @
	_baseUrl: '/api/v1/dispatch'
	alias: 'ad'
	_getUrl: (p, k, l) ->
		req = {}
		req.k = k if k
		req.l = l or 1
		@host.getHostWithProtocol() + @_baseUrl + "/#{p}?" + querystring.stringify req
	execute: (program, elements, keywords) ->
		return null if not program or not elements
		elements = [elements] if elements instanceof Array is false
		url = @_getUrl program, keywords, elements.length
		@http.get url, {withCredentials: true} , (body, status, obj) ->
			markupList = JSON.parse body
			elements[i].innerHTML = markup for markup, i in markupList

annotate AdCommand, new Inject HttpProvider, HostNameBuilder, CommandExecutor
module.exports = AdCommand
