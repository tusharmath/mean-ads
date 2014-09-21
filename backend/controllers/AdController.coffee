ModelManager = require '../models'
di = require 'di'
_ = require 'lodash'

class AdController
	constructor: (@modelManager) ->
		@model = @modelManager.models.SubscriptionModel
	_updateCredits: (subscription) ->
		usedCredits = subscription.usedCredits + 1
		@model
		.findByIdAndUpdate subscription._id, {usedCredits}
		.exec -> console.log 'Credits updated', {usedCredits}

	first: (req, res) ->
		@model
		.find campaignProgramId : req.params.id
		.where 	'campaignKeywords', req.query.keywords
		.exec (err, subscriptions) =>
			randomIndex = _.random 0, subscriptions.length - 1
			subscription = subscriptions[randomIndex]
			res.send subscription
			@_updateCredits subscription

di.annotate AdController, new di.Inject ModelManager

module.exports = AdController
