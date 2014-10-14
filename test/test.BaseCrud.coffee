ModelFactory = require '../backend/modules/ModelFactory'
Ctor = require '../backend/cruds/BaseCrud'
describe 'BaseCrud', ->
	[mod, models, injector] = [{} , {} ]
	beforeEach ->
		model = (obj) ->
			obj.saveQ = sinon.spy()
			obj

		class ModelFactoryProvider
			then: (resolve, reject) ->
				resolve models
		di.annotate ModelFactoryProvider, new di.Provide ModelFactory

		injector = new di.Injector [ModelFactoryProvider]
		mod = injector.get Ctor
		mod.model = model

	it 'should set model property', ->
		mod.models.should.equal models

	it 'should be a Singleton Instance', ->
		injector.get(Ctor).should.equal injector.get Ctor

	describe 'create()', ->
		it 'should exist', ->mod.create.should.be.a.Function
		it 'should set owner', (async) ->
			obj = {}
			mod.create obj, 'asd123'
			.done ->
				obj.owner.should.equal 'asd123'
				obj.saveQ.called.should.be.ok
				async()
