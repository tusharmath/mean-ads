logger = require 'bragi'
config = require './config'
compression = require 'compression'
minify = require 'express-minify'
module.exports = (app) ->

	app
	.use compression()
	.use minify()
	# Caching all HTTP responses
	.use (req, res, next) ->
		logger.log 'http:static:caching', req.url
		res.header 'Cache-Control', "public, max-age=#{config.cache.maxAge}"
		next()
