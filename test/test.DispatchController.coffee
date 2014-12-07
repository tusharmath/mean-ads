DispatchController = require '../backend/controllers/DispatchController'
Dispatcher = require '../backend/modules/Dispatcher'
errors = require '../backend/config/error-codes'
Q = require 'q'
{Injector} = require 'di'

describe 'DispatchController:', ->
	beforeEach ->
		@req = query: {}

		injector = new Injector
		@mod = injector.get DispatchController

		# Dispatcher
		@dispatcher = injector.get Dispatcher
		sinon.stub @dispatcher, 'next'
		.resolves 'sample-markup'


	describe "$ad()", ->

		it "calls resolve with dispatcher.next", ->
			@mod.actions.$ad @req
			.should.eventually.equal 'sample-markup'
		it "calls next", ->
			@req.query = p:'123234', k: ['a', 'b']
			@mod.actions.$ad @req
			.then => @dispatcher.next.calledWith '123234', ['a', 'b']
			.should.eventually.be.ok
