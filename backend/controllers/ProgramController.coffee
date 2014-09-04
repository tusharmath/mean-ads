BaseController = require './BaseControllerFactory'

class ProgramController
    constructor: () ->
        @model = @modelManager.models.ProgramModel
    ProgramController:: = injector.get BaseController

    list: (req, res) ->
        @model
        .find {}
        .limit 10
        .populate path: 'style', select: 'name'
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data


module.exports = ProgramController
