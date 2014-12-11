DispatchController = require '../backend/controllers/DispatchController'
Dispatcher = require '../backend/modules/Dispatcher'
errors = require '../backend/config/error-codes'
Q = require 'q'
{Injector} = require 'di'

describe 'DispatchController:', ->
	beforeEach ->
		@req = query: {}, headers:origin: 'alpha'
		@res = set: sinon.spy()


		injector = new Injector
		@mod = injector.get DispatchController

		# Dispatcher
		@dispatcher = injector.get Dispatcher
		sinon.stub @dispatcher, 'next'
		.resolves markup: 'sample-markup', allowedOrigins: ['a', 'b', 'c']



	describe "$ad()", ->

		it "calls resolve with dispatcher.next", ->
			@mod.actions.$ad @req, @res
			.should.eventually.equal 'sample-markup'
		it "calls next", ->
			@req.query = p:'123234', k: ['a', 'b']
			@mod.actions.$ad @req, @res
			.then => @dispatcher.next.calledWith '123234', ['a', 'b']
			.should.eventually.be.ok
		it "set cross origin headers", ->
			@req.headers = origin: 'a'
			@mod.actions.$ad @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Origin', 'a'
			.should.eventually.be.ok

		it "NOT set cross origin headers", ->
			@mod.actions.$ad @req, @res
			.then => @res.set.called.should.not.be.ok
		it "returns empty string", ->
			@dispatcher.next.resolves null
			@mod.actions.$ad @req, @res
			.should.eventually.equal ''

