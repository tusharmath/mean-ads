DispatchController = require '../backend/controllers/DispatchController'
Dispatcher = require '../backend/modules/Dispatcher'
errors = require '../backend/config/error-codes'
Q = require 'q'
{Injector} = require 'di'

describe 'DispatchController:', ->
	beforeEach ->
		@req = {}

		injector = new Injector
		@mod = injector.get DispatchController

		# Dispatcher
		@dispatcher = injector.get Dispatcher
		sinon.stub @dispatcher, 'next'
		.resolves 'sample-markup'


	describe "$ad()", ->

		it "calls dispatch.next", ->
			@req = p:'123234', k: ['a', 'b']
			@mod.$ad @req
			.should.eventually.equal 'sample-markup'
