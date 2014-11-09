Q = require 'q'
_ = require 'lodash'

class DispatchController

	# TODO: Can't think of a better way to handle custom routes
	actionMap:
		$ad: [ 'get', -> '/dispatch/ad']
		$css: [ 'get', -> '/dispatch/css/:styleId.css']
		$html: [ 'get', -> '/dispatch/html/:styleId.js']

	_querySubscription: (req) ->
		@Cruds.Subscription.query()
		.where campaignProgramId: req.query.p
		.sort lastDeliveredOn: 'asc'
		.findOne ''
		.execQ()

	_queryProgram: (req) -> @Cruds.Program.one req.query.p

	_touchSubscription: (subscription) ->
		subscription.lastDeliveredOn = Date.now()
		@Cruds.Subscription.update subscription
		.done()

	$css: (req, res) ->
		res.set 'Content-Type', 'text/css'
		@Cruds.Style.one req.params.styleId
		.then (doc)-> doc.css

	$html: (req, res) ->
		res.set 'Content-Type', 'application/javascript'
		@Cruds.Style.one req.params.styleId
		.then (doc) -> doc.html


	$ad: (req, res) ->
		Q.all [
			@_queryProgram req
			@_querySubscription req
		]
		.spread (program, subscription) ->
			@_touchSubscription subscription
			d: subscription.data
			s: program.style


	# Perfect place to mutate request
module.exports = DispatchController
