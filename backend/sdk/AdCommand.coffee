querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../providers/HttpProvider'
class AdCommand
	constructor: (@http) ->
	_baseUrl: '/api/v1/dispatch/ad?'

	_getUrl: (p, k) ->
		req = {p}
		req.k = k if k
		@_baseUrl + querystring.stringify req
	execute: (program, element, keywords) ->
		return null if not program or not element
		url = @_getUrl program, keywords
		@http.get url, (response) -> element.innerHTML = response


annotate AdCommand, new Inject HttpProvider
module.exports = AdCommand