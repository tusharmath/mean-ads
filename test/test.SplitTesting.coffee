SplitTesting = require '../backend/modules/SplitTesting'
mocks = require './mocks'
{Injector} = require 'di'

describe "SplitTesting", ->
	beforeEach ->
		# Injector
		@injector = new Injector [mocks]
		@mod = @injector.get SplitTesting
