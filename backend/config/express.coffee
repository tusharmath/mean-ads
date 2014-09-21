path = require 'path'
express = require 'express'
favicon = require 'static-favicon'
cookieParser = require 'cookie-parser'
config = require './config'
stylus = require 'stylus'
coffeeMiddleware = require 'coffee-middleware'
dev = require './express-dev'
prod = require './express-prod'

module.exports = (app) ->
	app.set 'jsonp callback name', 'mean'
	env = app.get 'env'

	dev app if env is 'development'
	prod app if env is 'production'

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
