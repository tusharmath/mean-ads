DispatchController = require '../backend/controllers/DispatchController'
errors = require '../backend/config/error-codes'
Q = require 'q'
{Injector} = require 'di'

describe 'DispatchController:', ->
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
	describe "_querySubscription()", ->
		it "be a function", -> @mod._querySubscription.should.be.a.Function
		it "calls query", ->
			@mod.Cruds = Subscription: query: sinon.stub().resolves()
			req = query:
				p : 123321
				k : ['a', 'b', 'c']
			@mod._querySubscription req
			.then =>

				@mod.Cruds.Subscription.query
				.getCall 0
				.args[0].should.eql [
					{where: program: 123321}
					{where: 'keywords'}
					{in: ['a', 'b', 'c']}
					{sort: lastDeliveredOn: 'asc'}
					'findOne'
				]
		it "calls query with single key", ->
			@mod.Cruds = Subscription: query: sinon.stub().resolves()
			req = query:
				p : 123321
				k : 'a'
			@mod._querySubscription req
			.then =>

				@mod.Cruds.Subscription.query
				.getCall 0
				.args[0].should.eql [
					{where: program: 123321}
					{where: 'keywords'}
					{in: ['a']}
					{sort: lastDeliveredOn: 'asc'}
					'findOne'
				]

		it "calls query with keys", ->
			@mod.Cruds = Subscription: query: sinon.stub().resolves()
			req = query:
				p : 123321
			@mod._querySubscription req
			.then =>
				@mod.Cruds.Subscription.query
				.getCall 0
				.args[0].should.eql [
					{where: program: 123321}
					{sort: lastDeliveredOn: 'asc'}
					'findOne'
				]

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