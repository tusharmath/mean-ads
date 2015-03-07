'use strict'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'
# process.env.NODE_ENV = 'production'
env = process.env.NODE_ENV || 'development'

config = _.merge(
	require './env/all.coffee'
	require './env/' + env + '.coffee' || {}
 )
config.controllers = fs.readdirSync './backend/controllers'
config.schemas = fs.readdirSync './backend/schemas'

if process.env.USER and env isnt 'production'
	userconfig = './user/' + process.env.USER + '.coffee'
	if fs.existsSync path.join path.join __dirname , userconfig
		config = _.merge(
			config
			require userconfig
		)
	else
		console.log 'User config not found, defaulting to development.coffee'

module.exports = config
