_ = require 'lodash'
{Inject, annotate} = require 'di'
BaseController = require './BaseController'

class CampaignController
	constructor: (@actions) ->
		@actions.resourceName = 'Campaign'
	$update: (req) ->
		_updatedResponse = {}
		@actions.$update.call @, req
		.then (updatedResponse) =>
			_updatedResponse = updatedResponse
			@dispatch.campaignUpdated req.params.id
		.then -> _updatedResponse

annotate CampaignController, new Inject BaseController
module.exports = CampaignController
