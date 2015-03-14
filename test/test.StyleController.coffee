BaseController = require '../backend/controllers/BaseController'
ioc = require './ioc'
{Injector} = require 'di'

describe 'StyleController:', ->
	beforeEach ->
		ioc.resolve 'controllers.StyleController'
		.bindOn @

	afterEach ->
		@afterEach()

	it "must have actions", ->
		@mod.actions.should.be.an.instanceOf BaseController
	it 'sets the post update hook', ->
		@mod.actions.postUpdateHook.should.equal @mod.postUpdateHook
	it "must have hasListOwner set to no", ->
		@mod.actions.hasListOwner.should.be.false
	it "must not have a $create action", ->
		should.not.exist @mod.actions.$create
