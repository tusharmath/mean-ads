logger = require 'bragi'
config = require './config'
compression = require 'compression'
minify = require 'express-minify'
module.exports = (app) ->

	app
	.use compression()
	.use minify()
	# Caching all HTTP responses
	.use /(\/static)|(\/templates)|(\/$)/, (req, res, next) ->
		logger.log 'http:caching', req.url
		res.header 'Cache-Control', "public, max-age=#{config.cache.maxAge}"
		next()

	# No caching for api requests
	.use '/api/v1', (req, res, next) ->
		logger.log 'http:no-caching', req.url
		res.header 'Cache-Control', "no-cache, max-age=0"
		next()
