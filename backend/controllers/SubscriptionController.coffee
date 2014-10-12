BaseController = require './BaseController'
Q = require 'q'

class SubscriptionController
	constructor: () ->
		@resource = 'Subscription'
		@_populate = path: 'campaign', select: 'name'
		@_filterKeys = ['campaign']

	# Perfect place to mutate request
module.exports = SubscriptionController
