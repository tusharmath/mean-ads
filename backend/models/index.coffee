glob = require 'glob'
_ = require 'lodash'
di = require 'di'
DbConnection = require '../db/DbConnection'

globOptions =
    cwd: './backend/models'
    sync: true

class ModelManager
    models : {}
    constructor: (@connection) ->
        if @connection.mongoose.connection.readyState isnt 1
            throw Error 'connection not available'
        glob '*Model.coffee', globOptions , (er, files) =>
            # TODO: Move it out
            _.each files, @load, @
            # console.log 'Models Loaded', Object.keys @models
    load: (file) ->
        file = file.replace '\.coffee', ''
        @models[file] = require("./#{file}") (@connection.mongoose)
di.annotate ModelManager, new di.Inject DbConnection
module.exports = ModelManager
