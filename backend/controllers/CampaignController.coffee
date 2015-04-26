_ = require 'lodash'
BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'

class CampaignController
	constructor: (@actions, @dispatch) ->
		@actions.resourceName = 'Campaign'
		@actions.postUpdateHook = @postUpdateHook
	postUpdateHook: (campaign) =>
		@dispatch.campaignUpdated campaign._id
		.then -> campaign

module.exports = CampaignController
