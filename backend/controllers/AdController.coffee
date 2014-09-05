ModelManager = require '../models'
Instantiable = require '../modules/Instantiable'
di = require 'di'
_ = require 'lodash'

class AdController
    constructor: (@modelManager) ->
        @model = @modelManager.models.SubscriptionModel

    list: (req, res) ->
        @model
        .findOne {}
        .sort {created:'descending'}
        .limit 1
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data


di.annotate AdController, new di.Inject ModelManager

module.exports = AdController
