RouteResolver = require '../backend/modules/RouteResolver'
ioc = require './ioc'

{Injector} = require 'di'

describe 'RouteResolver:', ->
	beforeEach ->
		ioc.resolve 'modules.RouteResolver'
		.bindOn @

	afterEach ->
		@afterEach()

	# describe "router()", ->
	# 	it "returns a val", ->
	# 		should.exist @mod.router()

	describe "_forEveryAction()", ->
		beforeEach ->
			sinon.stub @mod, '_actionBinder'
			@controllers =
				ctrl1: actions: $a:->
		it "calls _actionBinder actions",  ->
			@mod._forEveryAction {} , @controllers
			@mod._actionBinder.called.should.be.ok

		it "ignores _actionBinder actions",  ->
			@controllers =
				ctrl1: actions: $a: null
			@mod._forEveryAction {} , @controllers
			@mod._actionBinder.called.should.be.false

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
			.to.Throw 'actionMap has not been set for action: Apple: sample-name'