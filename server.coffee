'use strict'
bragi = require 'bragi'
di = require 'di'


# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV || process.argv[2] || 'development'
config = require './backend/config/config'


# Overriding console.log
global.bragi = bragi
bragi.options = config.bragi.options

#Global Injector
global.injector = new di.Injector

#Setup Express App
require './backend/express'
