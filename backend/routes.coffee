'use strict'
index = require './modules'
middleware = require './middleware'
api = require './routers/api'
bodyParser = require 'body-parser'
module.exports = (app) ->
    app.route('/modules/*').get index.partials
    app.route('/').get middleware.setUserCookie, index.index
    app.use '/api', bodyParser.json()
    app.use '/api/v1', (injector.get api).router
    app.route('*').all (req, res, next) -> res.render '404', 404
