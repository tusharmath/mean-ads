DispatchController = require '../backend/controllers/DispatchController'
Dispatcher = require '../backend/modules/Dispatcher'
DispatchStamper = require '../backend/modules/DispatchStamper'
errors = require '../backend/config/error-codes'
Q = require 'q'
{Injector} = require 'di'

describe 'DispatchController:', ->
	beforeEach ->
		@req =
			query: {}
			params: program: Date.now()
			signedCookies: {_sub: 'aa:111'}
			headers: {origin: 'alpha'}
		@res = set: sinon.spy(), cookie: sinon.spy()


		injector = new Injector
		@mod = injector.get DispatchController

		# Dispatcher
		@dispatcher = injector.get Dispatcher
		sinon.stub @dispatcher, 'next'
		.resolves markup: 'sample-markup', allowedOrigins: ['a', 'b', 'c']

		# DispatchStamper
		@stamper = injector.get DispatchStamper
		sinon.stub @stamper, 'appendStamp'
		.returns 'alpha-bravo-charlie'


	describe "$index()", ->

		it "calls resolve with dispatcher.next", ->
			@mod.actions.$index @req, @res
			.should.eventually.equal 'sample-markup'
		it "calls next", ->
			@req.query = k: ['a', 'b'], l: 100
			@mod.actions.$index @req, @res
			.then => @dispatcher.next.calledWith @req.params.program, {keywords: ['a', 'b'], limit: 100}
			.should.eventually.be.ok
		it "sends empty k if not an array", ->
			@req.query = k: 'xyz'
			@mod.actions.$index @req, @res
			.then =>
				@dispatcher.next.calledWithExactly @req.params.program, {limit: 1, keywords: []}
				.should.be.ok
				@dispatcher.next.calledOn @dispatcher
				.should.be.ok

		it "set Access-Control-Allow-Origin headers", ->
			@req.headers = origin: 'a'
			@mod.actions.$index @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Origin', 'a'
			.should.eventually.be.ok
		it "set Access-Control-Allow-Credentials headers", ->
			@req.headers = origin: 'a'
			@mod.actions.$index @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Credentials', true
			.should.eventually.be.ok
		it "NOT set cross origin headers", ->
			@mod.actions.$index @req, @res
			.then => @res.set.called.should.not.be.ok
		it "returns empty string", ->
			@dispatcher.next.resolves null
			@mod.actions.$index @req, @res
			.should.eventually.equal ''
		it "sets the subscription cookie", ->
			@mod.actions.$index @req, @res
			.then => @res.cookie.calledWith '_sub', 'alpha-bravo-charlie', signed: true
			.should.eventually.be.ok
		it "calls appendStamp with signed cookies", ->
			@mod.actions.$index @req, @res
			.then => @stamper.appendStamp.calledWith @req.signedCookies._sub
			.should.eventually.be.ok
