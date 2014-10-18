require 'coffee-errors'
require 'mock-promises'
chai = require 'chai'
global.should = chai.should()
chai.use require "chai-as-promised"
global.bragi = require 'bragi'
global.bragi.options.groupsEnabled = false
global.sinon = require 'sinon'
