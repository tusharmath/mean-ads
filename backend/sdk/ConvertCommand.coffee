querystring = require 'querystring'
{annotate, Inject} = require 'di'
HttpProvider = require '../providers/HttpProvider'
CreateImageElement = require './CreateImageElement'
HostNameBuilder = require './HostNameBuilder'
CommandExecutor = require './CommandExecutor'
class ConvertCommand
	constructor: (@host, @exec, @img) ->
		@exec.register @
	alias: 'convert'
	_getUrl: (id) ->
		@host.getHostWithProtocol() + "/api/v1/subscription/#{id}/convert.gif"
	execute: (subscriptionId) ->
		return null if not subscriptionId
		url = @_getUrl subscriptionId
		@img.create url

annotate ConvertCommand, new Inject HostNameBuilder, CommandExecutor, CreateImageElement
module.exports = ConvertCommand