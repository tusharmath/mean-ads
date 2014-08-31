config = require '../config/config'
mongoose = require 'mongoose'
class DbConnection
    connect: (callback) ->
        mongoose.connect config.mongo.uri
        db = mongoose.connection
        db.once 'open', =>
            @mongoose = mongoose
            callback @
        db.on 'error', -> console.error 'Could not connect to database'

module.exports = DbConnection
