BaseController = require './BaseControllerFactory'
class CampaignController
    constructor: () ->
        @model = @modelManager.models.CampaignModel
    CampaignController:: = injector.get BaseController

    list: (req, res) ->
        @model
        .find {}
        .limit 10
        .populate 'program', () ->console.log arguments

CampaignController:: = injector.get BaseController
module.exports = CampaignController
