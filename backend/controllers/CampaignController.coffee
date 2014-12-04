_ = require 'lodash'
BaseController = require './BaseController'

class CampaignController
	constructor: () ->
		@_populate = path: 'program', select: 'name'

	$update: (req) ->
		_updatedResponse = {}
		@_base.$update.call @, req
		.then (updatedResponse) =>
			_updatedResponse = updatedResponse
			@dispatch.campaignUpdated req.params.id
		.then -> _updatedResponse
module.exports = CampaignController
