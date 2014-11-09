[
	SubscriptionController
	MongooseProvider
	Mock
] = [
	require '../backend/controllers/SubscriptionController'
	require '../backend/providers/MongooseProvider'
	require './mocks'
]

{Injector} = require 'di'

describe 'SubscriptionController:', ->
	beforeEach ->
		#Initial Setup
		@req = {}
		@res = send: sinon.spy()

		# Injector
		@injector = new Injector Mock

		# Injections
		@mod = @injector.get SubscriptionController
		@mongP = @injector.get MongooseProvider
		# @mod.crud = @crudP.cruds.Subscription

		# @subM = @injector.get

	afterEach ->
		@mongP.__reset()

	describe "_cssRoute()", ->
		it 'creates url with programs'

	# describe "$ad()", ->
	# 	beforeEach ->
	# 		@req.query = p: '1q2w3e4r5t6y7u8i9o0p'
	# 		@doc = data: 123
	# 		@mod.crud =
	# 			query: sinon.stub().resolves @doc
	# 			update: sinon.stub().resolves 'doc-updated'

	# 	it "be a function", -> @mod.$ad.should.be.a.Function
	# 	it "calls query", ->
	# 		@mod.$ad @req, @res
	# 		@mod.crud.query.calledWith [
	# 			'where': campaignProgramId: '1q2w3e4r5t6y7u8i9o0p'
	# 			'sort': lastDeliveredOn: 'asc'
	# 			'findOne': ''
	# 		]
	# 		.should.be.ok

	# 	it "sends sub.data", ->
	# 		@mod.$ad(@req, @res).should.eventually.be.equal 123

	# 	it "updates delivery date", ->
	# 		@doc.lastDeliveredOn = 'random-text'
	# 		@mod.$ad(@req, @res).then =>
	# 			@doc.lastDeliveredOn.should.not.equal 'random-text'

	# 	it "updates subscription", ->
	# 		@mod.$ad(@req, @res).then =>
	# 			@mod.crud.update.calledWith(@doc).should.be.ok

	# 	it 'catches update errors', ->
	# 		@mod.crud.update.rejects new Error 'doc-not-updated'
	# 		@mod.$ad @req, @res
	# 		.then -> console.log arguments

		# it "sends link to css", ->
		# 	@req.query = p: 1, k: ['a', 'b', 'c']
		# 	@mod.$ad @req, @res
		# 	# @res.send.calledWith


		it "sends link to markup"

		it 'updates lastDeliveredOn'
