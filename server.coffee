'use strict'
express = require 'express'
logger = require 'bragi'


path = require 'path'
di = require 'di'
global.injector = new di.Injector
# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || process.argv[2] || 'development'
config = require './backend/config/config'
logger.options = config.bragi.options
app = express()
require('./backend/config/express') app
require('./backend/routes') app

# Start server
app.listen config.port, config.ip, ->
	logger.log(
		'application'
		logger.util.symbols.success
		'Server Started'
		logger.util.print("#{config.ip}:#{config.port}", 'yellow')
		'in'
		logger.util.print("#{app.get 'env'}", 'yellow')
		'mode'
	)

# Expose app
exports = module.exports = app;
