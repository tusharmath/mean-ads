errorHandler = require 'errorhandler'
livereload = require 'express-livereload'
config = require './config'
logger = require 'bragi'

module.exports = (app) ->
	livereload app, watchDir: "#{config.root}/frontend"
	app.use errorHandler()

	#TODO: only for certain paths?
	.use '/api', (req, res, next) ->
		logger.log 'http:api', logger.util.print(req.method, 'green'), req.url
		next()
	.use '/static', (req, res, next) ->
		logger.log 'http:caching', logger.util.print(req.method, 'green'), req.url
		next()

	#disables caching of scripts in development module
	.use (req, res, next) ->
		logger.log 'http:no-caching', req.url
		res.header 'Cache-Control', "no-cache, max-age=0"
		next()
