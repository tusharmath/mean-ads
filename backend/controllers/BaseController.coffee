ModelManager = require '../models'
di = require 'di'

class BaseController
    constructor: (@modelManager) ->

    # [POST] /resource
    create: (req, res) ->
        program = new @model req.body
        program.save (err) ->
            return res.send err, 400 if err
            res.send program
        # res.send program

    # [PUT] /resource
    update: (req, res) ->
        program = @model
        .findByIdAndUpdate req.params.id, req.body, (err) ->
            return res.send err, 400 if err
            res.send program
        # res.send program


    # [GET] /resource
    list: (req, res) ->
        @model
        .find {}
        .limit 10
        .populate path: 'style', select: 'name'
        .exec (err, data) ->
            return res.send err, 400 if err
            res.send data

    # [DELETE] /resource/:id
    remove: (req, res) ->
        @model
        .findByIdAndRemove req.params.id, -> res.send 'DELETED'

    # [GET] /resource/:id
    first: (req, res) ->
        @model.findById req.params.id, (err, data)->
            return res.send err, 400 if err
            res.send data

di.annotate BaseController, new di.Inject ModelManager
module.exports = BaseController
