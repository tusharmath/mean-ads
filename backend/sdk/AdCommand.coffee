querystring = require 'querystring'
{annotate, Inject} = require 'di'
class AdCommand
	constructor: (@http, @host, @exec, @windowP) ->
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
		{HTMLCollection} =  @windowP.window()
		if (
			elements instanceof Array is false and
			elements instanceof HTMLCollection is false
		)
			elements = [elements]
		url = @_getUrl program, keywords, elements.length
		@http.get url, {withCredentials: true} , (body, status, obj) ->
			markupList = JSON.parse body
			elements[i].innerHTML = markup for markup, i in markupList

annotate AdCommand, new Inject(
	require '../sdk/HttpProvider'
	require './HostNameBuilder'
	require './CommandExecutor'
	require '../providers/WindowProvider'
	)
module.exports = AdCommand
