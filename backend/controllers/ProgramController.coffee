BaseController = require './BaseController'

class ProgramController
    constructor: () ->
        @model = @modelManager.models.ProgramModel
    ProgramController:: = injector.get BaseController

    list: (req, res) ->
        @model
        .find {}
        .populate path: 'style', select: 'name'
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data

    # [GET] /resource/:id
    first: (req, res) ->
        @model
            .findById req.params.id
            .populate path: "style", select: 'name created placeholders'
            .exec (err, data) ->
                return res.send err, 400 if err
                res.send data

ProgramController:: = injector.get BaseController
module.exports = ProgramController
