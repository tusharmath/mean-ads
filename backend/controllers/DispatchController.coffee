{ErrorPool} = require '../config/error-codes'
{annotate, Inject} = require 'di'
_ = require 'lodash'

class DispatchController
	constructor: (@dispatch) ->
		@actions =
			actionMap: $index: [ 'get', -> '/dispatch/:program']
		@actions.$index = @$index
	cookieName: '_sub'
	_dispatcherOptions: (query) ->
		defaultOptions = k: [], l: 1
		{k, l} = _.assign defaultOptions, query
		k = [k] if not _.isArray k
		{keywords: k, limit: l}
	$index: (req, res) =>
		{origin} = req.headers
		{program} = req.params
		@dispatch.next program, @_dispatcherOptions req.query
		.then (dispatchList) =>
			return [] if dispatchList.length is 0
			allowedOrigins = @dispatch.getAllowedOrigins dispatchList
			if _.contains allowedOrigins, origin
				res.set 'Access-Control-Allow-Origin', origin
				res.set 'Access-Control-Allow-Credentials', true
			_.pluck dispatchList, 'markup'

annotate DispatchController, new Inject(
	require '../modules/Dispatcher'
	)
module.exports = DispatchController
