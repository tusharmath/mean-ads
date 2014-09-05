ModelManager = require '../models'
Instantiable = require '../modules/Instantiable'
di = require 'di'
_ = require 'lodash'

class AdController
    constructor: (@modelManager) ->
        @model = @modelManager.models.SubscriptionModel

    list: (req, res) ->

       @model
        .find {}
        .limit 10
        .exec (err, data) =>
            min = 0
            max = data.length
            randomIndex = Math.floor(Math.random() * (max - min) + min)
            return res.send err, 400 if err
            res.send "exec(#{JSON.stringify data[randomIndex]})"
            @model
            .findByIdAndUpdate data[randomIndex]._id, creditsRemaining: data[randomIndex].creditsRemaining-1
            .exec (err, data) =>


di.annotate AdController, new di.Inject ModelManager

module.exports = AdController
