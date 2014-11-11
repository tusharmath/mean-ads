DispatchController = require '../backend/controllers/DispatchController'
errors = require '../backend/config/error-codes'
{Injector} = require 'di'

describe 'DbConnection:', ->
	beforeEach ->
		injector = new Injector
		@mod = injector.get DispatchController

	describe "_queryProgram()", ->
		it "be a function", ->
			@mod._queryProgram.should.be.a.Function
		it "rejects with 400", ->
			req = query: {}
			expect =>
				@mod._queryProgram req
			.to.throw errors.INVALID_PARAMETERS