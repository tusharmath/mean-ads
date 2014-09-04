BaseController = require './BaseController'
class CampaignController
    constructor: () ->
        @model = @modelManager.models.CampaignModel
    CampaignController:: = injector.get BaseController

    list: (req, res) ->
        @model
        .find {}
        .populate path: 'program', select: 'name'
        .limit 10
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data

CampaignController:: = injector.get(BaseController).$resolve()
module.exports = CampaignController
