'use strict'
express = require 'express'
bragi = require 'bragi'


path = require 'path'
di = require 'di'
global.injector = new di.Injector
# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || process.argv[2] || 'development'
config = require './backend/config/config'
bragi.options = config.bragi.options

# Overriding console.log
global.bragi = bragi

app = express()
require('./backend/express') app

# Start server
app.listen config.port, config.ip, ->
	bragi.log(
		'application'
		bragi.util.symbols.success
		'Server Started'
		bragi.util.print("#{config.ip}:#{config.port}", 'yellow')
		'in'
		bragi.util.print("#{app.get 'env'}", 'yellow')
		'mode'
	)

# Expose app
exports = module.exports = app;
