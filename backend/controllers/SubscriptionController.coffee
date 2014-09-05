BaseController = require './BaseController'

class SubscriptionController
    constructor: () ->
        @model = @modelManager.models.SubscriptionModel
    SubscriptionController:: = base =  injector.get(BaseController).$resolve()

    create: (req, res) ->
        #TODO:
        #1. Use base class function
        #2. Move the default value assignment credit remanining in model

        req.body.creditsRemaining = req.body.totalCredits
        resource = new @model req.body
        console.log resource
        resource.save (err) ->
            return res.send err, 400 if err
            res.send resource

module.exports = SubscriptionController
