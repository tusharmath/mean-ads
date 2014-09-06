BaseController = require './BaseController'
ModelManager = require '../models'
Instantiable = require '../modules/Instantiable'
di = require 'di'

class CampaignController
    constructor: (@modelManager) ->
        @model = @modelManager.models.CampaignModel
    CampaignController:: = injector.get BaseController

    list: (req, res) ->

        @subscriptionModel = @modelManager.models.SubscriptionModel
        @model
        .find {}
        .populate path: 'program', select: 'name gauge'
        .limit 10
        .exec (err, data) =>
            return res.send err, 400 if err
            for campaign in data
                campaign.performance = Math.floor(Math.random() * 100)

                # @subscriptionModel
                # .where "campaign"
                # .equals campaign._id
                # .exec (err, subscriptionData) =>
                #     impression = 0
                #     for subscription in subscriptionData
                #         impression += (subscription.totalCredits - subscription.creditsRemaining)
                #     campaign.performance = impression

                #     return res.send err, 400 if err
                #     i++

                #     if i is data.length
            res.send data



CampaignController:: = injector.get(BaseController).$resolve()
di.annotate CampaignController, new di.Inject ModelManager

module.exports = CampaignController
