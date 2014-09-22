BaseController = require './BaseController'

class CampaignController
	constructor: () ->
		@model = @modelManager.models.CampaignModel
		@_populate = path: 'program', select: 'name gauge'
	CampaignController:: = injector.get BaseController

module.exports = CampaignController
