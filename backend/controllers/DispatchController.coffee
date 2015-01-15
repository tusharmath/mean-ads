{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'
_ = require 'lodash'

class DispatchController
	constructor: (@dispatch, @stamper) ->
		@actions =
			actionMap: $index: [ 'get', -> '/dispatch/:program']
		@actions.$index = @$index
	cookieName: '_sub'
	_dispatcherOptions: (query) ->
		defaultOptions = k: [], l: 1
		{k, l} = _.assign defaultOptions, query
		k = [] if not _.isArray k
		{keywords: k, limit: l}
	$index: (req, res) =>
		{origin} = req.headers
		{program} = req.params
		@dispatch.next program, @_dispatcherOptions req.query
		.then (dispatch) =>
			return '' if not dispatch
			if _.contains dispatch.allowedOrigins, origin
				res.set 'Access-Control-Allow-Origin', origin
				res.set 'Access-Control-Allow-Credentials', true
			dispatchStamp = @stamper.appendStamp req.signedCookies[@cookieName], dispatch
			res.cookie @cookieName, dispatchStamp, signed: true
			dispatch.markup

annotate DispatchController, new Inject(
	require '../modules/Dispatcher'
	require '../modules/DispatchStamper'
	)
module.exports = DispatchController
