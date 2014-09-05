path = require 'path'
express = require 'express'
favicon = require 'static-favicon'
cookieParser = require 'cookie-parser'
errorHandler = require 'errorhandler'
session = require 'express-session'
config = require './config'
mongoStore = require('connect-mongo') session
liveReload = require 'express-livereload'
stylus = require 'stylus'
coffeeMiddleware = require 'coffee-middleware'

module.exports = (app) ->
    env = app.get 'env'
    if env is 'development'
        liveReload app, watchDir: path.join config.root, 'frontend'
        app.use errorHandler()
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
    .use '/static', express.static path.join(config.root, 'frontend')
    .use '/static', coffeeMiddleware
        compress: config.coffeeCompress
        src: path.join config.root, 'frontend'
    .use '/static', stylus.middleware
        serve: false
        force: true
        src: path.join config.root, 'frontend/stylus'
        dest: path.join config.root, 'frontend/css'

    .set 'views', "#{config.root}/frontend"
    .set 'view engine', 'jade'
    .use cookieParser()
    .use session
        secret: 'my-little-secret'
        store: sessionStore
