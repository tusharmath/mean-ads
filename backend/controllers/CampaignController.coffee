BaseController = require './BaseController'
ModelManager = require '../models'
di = require 'di'

class CampaignController
	constructor: (@modelManager) ->
		@model = @modelManager.models.CampaignModel
		@_populate = path: 'program', select: 'name gauge'
	CampaignController:: = injector.get BaseController

di.annotate CampaignController, new di.Inject ModelManager

module.exports = CampaignController
