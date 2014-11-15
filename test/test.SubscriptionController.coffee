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