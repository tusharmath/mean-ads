'use strict'
index = require './modules'
middleware = require './middleware'
api = require './routers/api'
module.exports = (app) ->
    app.route('/modules/*').get index.partials
    app.route('/').get middleware.setUserCookie, index.index
    app.use '/api/v1', api.v1
    app.route('*').all (req, res, next) -> res.render '404', 404
