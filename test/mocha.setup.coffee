require 'coffee-errors'
require 'mock-promises'
chai = require 'chai'
global.should = chai.should()
global.expect = chai.expect
chai.use require "chai-as-promised" #Used to test Glob
global.bragi = require 'bragi'
global.bragi.options.groupsEnabled = false
global.sinon = require 'sinon'
