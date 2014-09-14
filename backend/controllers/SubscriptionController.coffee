BaseController = require './BaseController'

class SubscriptionController
	constructor: () ->
		@model = @modelManager.models.SubscriptionModel
		@_populate = path: 'campaign', select: 'name'
	SubscriptionController:: = base = injector.get BaseController
	# Perfect place to mutate request
	createReqMutator: (reqBody) ->
		reqBody.usedCredits = 0

module.exports = SubscriptionController
