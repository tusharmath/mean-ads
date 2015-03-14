RouteResolver = require '../backend/modules/RouteResolver'
MongooseProviderMock = require './mocks/MongooseProviderMock'
express = require 'express'
{Injector} = require 'di'

describe 'RouteResolver:', ->
	beforeEach ->
		@injector = new Injector [MongooseProviderMock]
		@Models = @injector.getModule 'factories.ModelFactory', mock: false
		@mod = @injector.get RouteResolver
	afterEach ->
		@Models.mongooseP.__reset()

	# describe "router()", ->
	# 	it "returns a val", ->
	# 		should.exist @mod.router()

	describe "_resolveRoute()", ->
		it "throws if actions not defined", ->
			ctrl = {}
			actionName = 'sample-name'
			expect =>
				@mod._resolveRoute ctrl, 'Apple', actionName
			.to.Throw 'actions have not been set for controller: Apple'
		it "throws if actionMap not defined", ->
			ctrl = actions: {}
			actionName = 'sample-name'
			expect =>
				@mod._resolveRoute ctrl,'Apple', actionName
			.to.Throw 'actionMap has not been set for action: sample-name'