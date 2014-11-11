'use strict'

bragi = require 'bragi'
di = require 'di'
Q = require 'q'
require 'newrelic'
config = require './backend/config/config'
Q.longStackSupport = config.Q.longStackSupport

global.bragi = bragi
# Overriding Logger return value
# logOverride = (_log) ->
# 	(args...) ->
# 		_log.apply bragi, args
# 		undefined
# bragi.log = logOverride bragi.log

bragi.options = config.bragi.options

#Setup Express App
require './backend/express'