BaseCrud = require '../backend/cruds/BaseCrud'
_ = require 'lodash'
ModelProvider = require '../backend/providers/ModelProvider'

Mock = require './mocks'
{Injector} = require 'di'


describe 'BaseCrud:', ->
	beforeEach ->
		@injector = new Injector Mock
		@FakeModel =
			find: -> @
			populate: -> @
			findById: -> @
			findOne: -> @
			execQ: -> @
		@modelProvider = @injector.get ModelProvider
		@modelProvider.models = FakeResource: @FakeModel

		_.each @FakeModel, (a, key) => sinon.spy @FakeModel, key
		@mod = @injector.get BaseCrud
		@mod.resourceName = 'FakeResource'


	it 'scope is transient', ->
		@mod.should.not.equal @injector.get BaseCrud

	it "set Models", ->
		@mod.Models.should.equal @modelProvider.models

	it "set model", ->
		@mod.model.should.equal @modelProvider.models.FakeResource

	describe "read()", ->
		it "is function", -> @mod.read.should.be.a.Function
		it "reads", -> @mod.read()
		it "filters on user", ->
			userId = 1234
			@mod.read 'grumpy pumpy', filterParam: 1, userId
			@FakeModel.find.calledWith filterParam: 1, owner: userId
			.should.be.ok

	describe "one()", ->
		it "is function", -> @mod.read.should.be.a.Function
		it "filters on user", ->
			@mod.one 1234, 2345
			@FakeModel.findOne.calledWith owner: 2345, _id: 1234
			.should.be.ok


