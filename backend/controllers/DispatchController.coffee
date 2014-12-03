Dispatcher = require '../modules/Dispatcher'
{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'

class DispatchController

	constructor: (@dispatch) ->
	actionMap:
		$ad: [ 'get', -> '/dispatch/ad']

	$ad: (req) ->
		@dispatch.next req.p, req.k

annotate DispatchController, new Inject Dispatcher
module.exports = DispatchController
