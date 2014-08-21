path = require 'path'
express = require 'express'
favicon = require 'static-favicon'
cookieParser = require 'cookie-parser'
errorHandler = require 'errorhandler'
session = require 'express-session'
config = require './config'
mongoStore = require('connect-mongo') session
liveReload = require 'connect-livereload'
coffeeMiddleware = requre 'coffee-middleware'

module.exports = (app) ->
    env = app.get 'env'
    if env is 'development'
        app
        .use liveReload()
        .use errorHandler()

        #disables caching of scripts in development module
        #TODO: only for certain paths?
        .use (req, res, next) ->
            res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
            res.header 'Pragma', 'no-cache'
            res.header 'Expires', 0
            next()

    sessionStore = new mongoStore
        url: config.mongo.uri
        collection: 'sessions'

    app
    .use express.static path.join config.root, '.tmp'
    .use express.static path.join config.root, 'frontend'
    .use coffeeMiddleware
        compress: config.coffeeCompress
        src: path.join config.root, 'frontend'
    .set 'views', "#{config.root}/frontend"
    .set 'view engine', 'jade'
    .use cookieParser()
    .use session
        secret: 'my-little-secret'
        store: sessionStore
