'use strict'

index = require './modules'
middleware = require './middleware'
###---require modules---###
###---require modules---###
module.exports = (app) ->
    app.route '/modules/*'
        .get index.partials
    app.route '/'
        .get middleware.setUserCookie, index.index
    app.route '*'
        .all (req, res, next) ->
            res.render '404', 404
