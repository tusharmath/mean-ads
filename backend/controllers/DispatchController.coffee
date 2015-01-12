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
		{k,p} = req.query
		nextArgs = [p]
		nextArgs.push k if _.isArray k
		@dispatch.next.apply @dispatch, nextArgs
		.then (dispatch) =>
			return '' if not dispatch
			if _.contains dispatch.allowedOrigins, origin
				res.set 'Access-Control-Allow-Origin', origin
				res.set 'Access-Control-Allow-Credentials', true
			dispatchStamp = @stamper.appendStamp req.signedCookies[@cookieName], dispatch
			res.cookie @cookieName, dispatchStamp, signed:true
			dispatch.markup

annotate DispatchController, new Inject(
	require '../modules/Dispatcher'
	require '../modules/DispatchStamper'
	)
module.exports = DispatchController
