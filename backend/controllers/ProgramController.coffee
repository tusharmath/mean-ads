ModelManager = require '../models'
di = require 'di'

class ProgramController
    constructor: (modelManager) ->
        @ProgramModel = modelManager.models.ProgramModel

    # [POST] /programs
    create: (req, res) ->
        program = new @ProgramModel req.body
        program.save (err) ->
            res.send program
        # res.send program

    # [GET] /programs
    list: (req, res) ->
        @ProgramModel
        .find {}
        .limit 10
        .exec (err, data) -> res.send data

    # [DELETE] /programs
    remove: (req, res) ->
        @ProgramModel
        .findByIdAndRemove req.body._id, -> res.send 'DELETED'
di.annotate ProgramController, new di.Inject ModelManager
module.exports = ProgramController
