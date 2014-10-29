DbConnection = require '../backend/connections/DbConnection'
Mock = require './mocks'

{Injector} = require 'di'

describe 'DbConnection:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get DbConnection

	it "no public mongoose", ->
		should.not.exist @mod.mongoose
