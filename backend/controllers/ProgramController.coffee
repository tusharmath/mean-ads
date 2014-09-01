ModelManager = require '../models'
di = require 'di'

class ProgramController
    constructor: (modelManager) ->
        @ProgramModel = modelManager.models.ProgramModel

    # [POST] /programs
    create: (req, res) ->
        program = new @ProgramModel req.body
        program.save (err) ->
            return res.send err, 400 if err
            res.send program
        # res.send program

    # [GET] /programs
    list: (req, res) ->
        @ProgramModel
        .find {}
        .limit 10
        .populate path: 'style', select: 'name'
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data

    # [DELETE] /programs
    remove: (req, res) ->
        @ProgramModel
        .findByIdAndRemove req.params.id, -> res.send 'DELETED'
di.annotate ProgramController, new di.Inject ModelManager
module.exports = ProgramController
