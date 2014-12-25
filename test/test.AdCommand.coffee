AdCommand = require '../backend/sdk/AdCommand'
CommandExecutor = require '../backend/sdk/CommandExecutor'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
HttpProvider = require '../backend/providers/HttpProvider'
HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "AdCommand", ->
	beforeEach ->
		# Injector
		@injector = new Injector [HttpProviderMock]
		@mod = @injector.get AdCommand

		# HostNameBuilder
		@hostName = @injector.get HostNameBuilder
		sinon.stub(@hostName, 'getHost').returns 'mean-ads.io'

		# HttpProvider
		@http = @injector.get HttpProvider
		sinon.spy @http, 'get'

		# CommandExecutor
		@exec = @injector.get CommandExecutor

	describe "constructor()", ->
		it "should register on cmdexec", ->
			@exec._executables['ad'].should.exist

	describe "execute()", ->
		beforeEach ->
			sinon.stub @mod, '_getUrl'
			.returns 'fake-http-url'
			@program = 102
			@element = {}

		it "be a function", -> @mod.execute.should.be.a.Function
		it "returns null if program is empty",  ->
			expect @mod.execute()
			.to.equal null
		it "calls http.get",  ->
			@mod.execute @program, @element
			@http.get.calledWith 'fake-http-url'
			.should.be.ok
		it "updates the innerHtml", ->
			@mod.execute @program, @element
			@http.$flush '<fake-response></fake-response>'
			@element.innerHTML = '<fake-response></fake-response>'

	describe "_getUrl()", ->
		it "creates query params with both p and k", ->
			@mod._getUrl 'abc', ['a','b', 'c']
			.should.equal '//mean-ads.io/api/v1/dispatch/ad?p=abc&k=a&k=b&k=c'
		it "creates query params with only p", ->
			@mod._getUrl 'abc'
			.should.equal '//mean-ads.io/api/v1/dispatch/ad?p=abc'