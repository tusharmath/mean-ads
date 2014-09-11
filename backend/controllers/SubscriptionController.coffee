BaseController = require './BaseController'

class SubscriptionController
    constructor: () ->
        @model = @modelManager.models.SubscriptionModel
    SubscriptionController:: = base =  injector.get BaseController

    create: (req, res) ->
        #TODO:
        #1. Use base class function
        #2. Move the default value assignment credit remanining in model

        req.body.creditsRemaining = req.body.totalCredits
        resource = new @model req.body

        resource.save (err) ->
            return res.send err, 400 if err
            res.send resource

    list: (req, res) ->
        @model
        .find {}
        .populate path: 'campaign'
        .limit 10
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data

module.exports = SubscriptionController
