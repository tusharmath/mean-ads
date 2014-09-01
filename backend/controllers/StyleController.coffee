ModelManager = require '../models'
di = require 'di'

class StyleController
    constructor: (modelManager) ->
        @StyleModel = modelManager.models.StyleModel

    # [POST] /programs
    create: (req, res) ->
        program = new @StyleModel req.body
        program.save (err) ->
            return res.send err, 400 if err
            res.send program
        # res.send program

    # [GET] /programs
    list: (req, res) ->
        @StyleModel
        .find {}
        .limit 10
        .exec (err, data) -> res.send data

    # [DELETE] /programs
    remove: (req, res) ->
        @StyleModel
        .findByIdAndRemove req.params.id, -> res.send 'DELETED'
di.annotate StyleController, new di.Inject ModelManager
module.exports = StyleController
