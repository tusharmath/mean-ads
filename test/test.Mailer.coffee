Mailer = require  '../backend/modules/Mailer'
JadeProvider = require '../backend/providers/JadeProvider'
{Injector} = require 'di'

describe 'Mailer:', ->
	beforeEach ->
		@injector = new Injector

		# Mailer
		@mod = @injector.get Mailer
		# Template Function
		@templateFn = sinon.stub().returns '<div>hi</div>'
		# JadeProvider
		@jade = @injector.get JadeProvider
		sinon.stub @jade, 'compileFile'
		.returns @templateFn

	describe "interpolate()", ->
		it "be a function", -> @mod.interpolate.should.be.a.Function
		it "compiles jade templates", ->
			template = 'subscription-report'
			@mod.interpolate template
			@jade.compileFile.calledWith "./frontend/templates/mailers/subscription-report.jade"
			.should.be.ok
		it "compiles jade templates", ->
			template = 'subscription-report'
			locals = a: 1, b: 2
			@mod.interpolate template, locals
			@templateFn.calledWith locals
			.should.be.ok





