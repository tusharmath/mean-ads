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
		it "sends empty strings", ->
			req = query: {}
			expect @mod._queryProgram req
			.to.equal null
	describe "$ad()", ->
		it "returns empty string if program resolves null", ->
			sinon.stub(@mod, '_queryProgram').resolves null
			sinon.stub(@mod, '_querySubscription')
			@mod.$ad {}, {}
			.should.eventually.be.equal ''

		it "returns empty string if program returns null", ->
			sinon.stub(@mod, '_queryProgram').returns null
			sinon.stub(@mod, '_querySubscription')
			@mod.$ad {}, {}
			.should.eventually.be.equal ''

		it "returns empty string if subscription resolves null", ->
			sinon.stub(@mod, '_queryProgram')
			sinon.stub(@mod, '_querySubscription').resolves null
			@mod.$ad {}, {}
			.should.eventually.be.equal ''
