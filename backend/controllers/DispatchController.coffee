Q = require 'q'
_ = require 'lodash'
dot = require 'dot'
CleanCss = require('clean-css')
cssMin = new CleanCss
class DispatchController

	# TODO: Can't think of a better way to handle custom routes
	actionMap:
		$ad: [ 'get', -> '/dispatch/ad']

	_querySubscription: (req) ->
		@Cruds.Subscription.query()
		.where campaignProgramId: req.query.p
		.sort lastDeliveredOn: 'asc'
		.findOne ''
		.execQ()

	_queryProgram: (req) ->
		@Cruds.Program.one req.query.p, 'style'


	_touchSubscription: (subscription) ->
		delta =
			usedCredits: subscription.usedCredits + 1
			lastDeliveredOn: Date.now()
		@Cruds.Subscription
		.update delta, subscription._id
		.done()

	_interpolate: (html, data) ->
		dot.template(html, strip: true) data

	_setCorsHeader: (program, req, res) ->
		origin = req.headers.origin
		if _.contains program.allowedOrigins, origin
			res.set 'Access-Control-Allow-Origin', origin

	_payload: (style, subscription) ->
		c: cssMin.minify style.css
		t: @_interpolate style.html, subscription.data

	$ad: (req, res) ->
		Q.all [
			@_queryProgram req
			@_querySubscription req
		]
		.spread (program, subscription) =>
			@_touchSubscription subscription
			@_setCorsHeader program, req, res
			@_payload program.style, subscription


	# Perfect place to mutate request
module.exports = DispatchController
