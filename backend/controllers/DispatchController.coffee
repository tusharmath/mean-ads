Dispatcher = require '../modules/Dispatcher'
DispatchStamper = require '../modules/DispatchStamper'
{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'
_ = require 'lodash'

class DispatchController
	constructor: (@dispatch, @stamper) ->
		@actions =
			actionMap:
				$ad: [ 'get', -> '/dispatch/ad']
		@actions.$ad = @$ad
	cookieName: '_sub'
	$ad: (req, res) =>
		{origin} = req.headers
		@dispatch.next req.query.p, req.query.k
		.then (dispatch) =>
			return '' if not dispatch
			if _.contains dispatch.allowedOrigins, origin
				res.set 'Access-Control-Allow-Origin', origin
			dispatchStamp = @stamper.appendStamp req.signedCookies[@cookieName], dispatch
			res.cookie @cookieName, dispatchStamp, signed:true
			dispatch.markup

annotate DispatchController, new Inject Dispatcher, DispatchStamper
module.exports = DispatchController
