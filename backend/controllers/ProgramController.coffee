ProgramModel = require '../models/ProgramModel'

class ProgramController
    constructor: () ->

    # [POST] /programs
    create: (req, res) ->
        program = new ProgramModel req.body
        program.save (err) ->
            res.send program
        # res.send program

    # [GET] /programs
    list: (req, res) ->
        @ProgramModel
        .limit 10
        .exec (data) ->res.send data

module.exports = ProgramController
