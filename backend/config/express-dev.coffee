errorHandler = require 'errorhandler'
config = require './config'
logger = require 'bragi'

module.exports = (app) ->
	app.use errorHandler()

	#TODO: only for certain paths?
	.use '/api', (req, res, next) ->
		logger.log 'http:api', logger.util.print(req.method, 'green'), req.url
		next()
	.use '/static', (req, res, next) ->
		logger.log 'http:static', logger.util.print(req.method, 'green'), req.url
		next()
	# Caching all HTTP responses

	#disables caching of scripts in development module
	.use (req, res, next) ->
		logger.log 'http:static:caching', req.url
		res.header 'Cache-Control', "no-cache, max-age=0"
		next()
