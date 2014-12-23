Mailer = require  '../backend/modules/Mailer'
JadeProvider = require '../backend/providers/JadeProvider'
MailgunProvider = require '../backend/providers/MailgunProvider'
JuiceProvider = require '../backend/providers/JuiceProvider'
{Injector} = require 'di'

describe 'Mailer:', ->
	beforeEach ->
		@injector = new Injector

		# Mailer
		@mod = @injector.get Mailer

		# MailGun
		@mail = @injector.get MailgunProvider

		# Juice
		@juice = @injector.get JuiceProvider

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

	describe "sendQ()", ->
		beforeEach ->
			# Spy & Stubs
			sinon.stub(@mail, 'sendQ').resolves 'hey there' #WILL SEND A REAL EMAIL IF NOT STUBBED
			sinon.stub(@mod, 'interpolate').returns '<div> whoopie </div>'
			sinon.stub(@juice, 'juiceContentQ').resolves '<div> poopie </div>'

			# Defaults
			@options =
				from: 'bizcostsavers <noreply@meanads.com>'
				to: 'tusharmath@gmail.com'
				subject: 'waddup guys'
				template: '<div>hi</div>'
				locals: a:1, b:2
		it "it calls interpolate", ->
			@mod.sendQ @options
			.then => @mod.interpolate.calledWith @options.template, @options.locals
			.should.eventually.be.ok
		it "it calls juiceContent", ->
			@mod.sendQ @options
			.then => @juice.juiceContentQ.calledWith '<div> whoopie </div>'
			.should.eventually.be.ok

