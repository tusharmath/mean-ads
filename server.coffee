'use strict'
express = require 'express'
path = require 'path'
di = require 'di'
global.injector = new di.Injector
# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || process.argv[2] || 'development'
config = require './backend/config/config'
DbConnection = require './backend/connections/DbConnection'
db = injector.get DbConnection
app = express()

db.connect (mongoose) ->
	console.log 'DB Connected!'
	require('./backend/config/express') app
	require('./backend/routes') app

	# Start server
	app.listen config.port, config.ip, ->
	console.log 'Express server listening on %s:%d, in %s mode', config.ip, config.port, app.get 'env'

# Expose app
exports = module.exports = app;
