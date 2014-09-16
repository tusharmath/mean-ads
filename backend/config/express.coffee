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
logger = require 'bragi'
logger.options = config.bragi.options
compression = require 'compression'

module.exports = (app) ->
	app.set 'jsonp callback name', 'mean'
	env = app.get 'env'
	if env is 'development'
		liveReload app, watchDir: path.join config.root, 'frontend'
		app.use errorHandler()
		#disables caching of scripts in development module
		#TODO: only for certain paths?
		.use '/api', (req, res, next) ->
			logger.log 'http:api', logger.util.print(req.method, 'green'), req.url
			next()
		.use '/static', (req, res, next) ->
			logger.log 'http:static', logger.util.print(req.method, 'green'), req.url
			next()

	sessionStore = new mongoStore
		url: config.mongo.uri
		collection: 'sessions'

	app

	# Caching all HTTP responses
	.use compression()
	.use (req, res, next) ->
		logger.log 'http:static:caching', req.url
		res.header 'Cache-Control', "public, max-age=#{config.cache.maxAge}"
		next()

	.use '/static', coffeeMiddleware
		compress: config.coffeeCompress
		src: path.join config.root, 'frontend'

	.use '/static', stylus.middleware
		force: config.stylus.forceCompile
		src: path.join config.root, 'frontend/stylus'
		dest: path.join config.root, 'frontend/css'

	.use '/static', express.static path.join(config.root, 'frontend')

	.set 'views', "#{config.root}/frontend"
	.set 'view engine', 'jade'
	.use cookieParser()
	.use session
		secret: 'my-little-secret'
		store: sessionStore
