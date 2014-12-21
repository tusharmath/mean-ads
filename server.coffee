'use strict'
require 'newrelic'
bragi = require 'bragi'
di = require 'di'
Q = require 'q'

config = require './backend/config/config'
Q.longStackSupport = config.Q.longStackSupport

global.bragi = bragi
bragi.options = config.bragi.options

#Setup Express App
require './backend/express'