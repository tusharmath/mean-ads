Q = require 'q'
_ = require 'lodash'
dot = require 'dot'
CleanCss = require('clean-css')
cssMin = new CleanCss
errors = require '../config/error-codes'
dot.templateSettings.strip = true
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

		return null if not req.query.p
		@Cruds.Program.one req.query.p, 'style'


	_touchSubscription: (subscription) ->
		delta =
			usedCredits: subscription.usedCredits + 1
			lastDeliveredOn: Date.now()
		@Cruds.Subscription
		.update delta, subscription._id
		.done()

	_interpolate: (html, data) -> dot.template(html) data

	_setCorsHeader: (program, req, res) ->
		origin = req.headers.origin
		if _.contains program.allowedOrigins, origin
			res.set 'Access-Control-Allow-Origin', origin

	_payload: (style, subscription) ->
		@_interpolate style.html, subscription.data
		css = cssMin.minify style.css
		tmpl = @_interpolate style.html, subscription.data
		"<style>#{css}</style>#{tmpl}"

	$ad: (req, res) ->
		Q.all [
			@_queryProgram req
			@_querySubscription req
		]
		.spread (program, subscription) =>
			return '' if program is null or subscription is null
			@_touchSubscription subscription
			@_setCorsHeader program, req, res
			@_payload program.style, subscription


	# Perfect place to mutate request
module.exports = DispatchController
