_ = require 'lodash'
{Inject, annotate} = require 'di'
BaseController = require './BaseController'
Dispatcher = require '../modules/Dispatcher'

class CampaignController
	constructor: (@actions, @dispatch) ->
		@actions.resourceName = 'Campaign'
		@actions.postUpdateHook = @postUpdateHook
	postUpdateHook: (campaign) =>
		@dispatch.campaignUpdated campaign._id
		.then -> campaign

annotate CampaignController, new Inject BaseController, Dispatcher
module.exports = CampaignController
