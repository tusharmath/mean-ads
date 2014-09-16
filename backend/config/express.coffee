path = require 'path'
express = require 'express'
favicon = require 'static-favicon'
cookieParser = require 'cookie-parser'
session = require 'express-session'
config = require './config'
mongoStore = require('connect-mongo') session
stylus = require 'stylus'
coffeeMiddleware = require 'coffee-middleware'
dev = require './express-dev'
prod = require './express-prod'

module.exports = (app) ->
	app.set 'jsonp callback name', 'mean'
	env = app.get 'env'

	dev app if env is 'development'
	prod app if env is 'production'

	sessionStore = new mongoStore
		url: config.mongo.uri
		collection: 'sessions'

	app
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
