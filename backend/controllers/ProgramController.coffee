BaseController = require './BaseController'

class ProgramController
    constructor: () ->
        @model = @modelManager.models.ProgramModel

    # [GET] /programs
    list: (req, res) ->
        @model
        .find {}
        .limit 10
        .populate path: 'style', select: 'name'
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data
ProgramController:: = injector.get BaseController
module.exports = ProgramController
