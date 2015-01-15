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
		@mod = injector.getModule 'controllers.DispatchController', mock: false

		# Dispatcher
		@dispatcher = injector.getModule 'modules.Dispatcher'
		@dispatcher.next.resolves [markup: 'sample-markup']
		@dispatcher.getAllowedOrigins.returns ['http://a.com', 'http://b.com']

	describe "$index()", ->

		it "calls resolve with dispatcher.next", ->
			@mod.actions.$index @req, @res
			.should.eventually.deep.equal ['sample-markup']
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
			@req.headers = origin: 'http://a.com'
			@mod.actions.$index @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Origin', 'http://a.com'
			.should.eventually.be.ok
		it "set Access-Control-Allow-Credentials headers", ->
			@req.headers = origin: 'http://a.com'
			@mod.actions.$index @req, @res
			.then => @res.set.calledWith 'Access-Control-Allow-Credentials', true
			.should.eventually.be.ok
		it "NOT set cross origin headers", ->
			@mod.actions.$index @req, @res
			.then => @res.set.called.should.not.be.ok
		it "returns empty array", ->
			@dispatcher.next.resolves []
			@mod.actions.$index @req, @res
			.should.eventually.deep.equal []
