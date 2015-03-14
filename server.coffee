'use strict'
config = require './backend/config/config'
require 'newrelic'
bragi = require 'bragi'
di = require 'di'
Q = require 'q'

if config.nodetime.enabled
	require 'nodetime'
	.profile(
	    accountKey: config.nodetime.accountKey
	    appName: config.appName
	)
Q.longStackSupport = config.Q.longStackSupport

global.bragi = bragi
bragi.options = config.bragi.options

#Setup Express App
require './backend/express'