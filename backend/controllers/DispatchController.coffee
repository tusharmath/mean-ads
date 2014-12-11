Dispatcher = require '../modules/Dispatcher'
{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'
_ = require 'lodash'

class DispatchController
	constructor: (@dispatch) ->
		@actions =
			actionMap:
				$ad: [ 'get', -> '/dispatch/ad']
		@actions.$ad = @$ad
	$ad: (req, res) =>
		{origin} = req.headers
		@dispatch.next req.query.p, req.query.k
		.then (dispatch) ->
			return '' if not dispatch
			if _.contains dispatch.allowedOrigins, origin
				res.set 'Access-Control-Allow-Origin', origin

			dispatch.markup

annotate DispatchController, new Inject Dispatcher
module.exports = DispatchController
