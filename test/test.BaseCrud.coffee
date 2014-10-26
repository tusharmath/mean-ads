BaseCrud = require '../backend/cruds/BaseCrud'
ModelProvider = require '../backend/providers/ModelProvider'

Mock = require './mocks'
{Injector} = require 'di'


describe 'BaseCrud:', ->
	beforeEach ->
		@injector = new Injector Mock

		@modelProvider = @injector.get ModelProvider
		@modelProvider.models =
			FakeResource:
				find: -> @
				populate: -> @
				findById: -> @
				execQ: -> @

		@mod = @injector.get BaseCrud
		@mod.resourceName = 'FakeResource'


	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseCrud

	it "set Models", ->
		@mod.Models.should.equal @modelProvider.models

	it "set model", ->
		@mod.model.should.equal @modelProvider.models.FakeResource

	describe "read", ->
		it "is function", ->
			@mod.read.should.be.a.Function
		it "reads", ->
			@mod.read()
