AdCommand = require '../backend/sdk/AdCommand'
CommandExecutor = require '../backend/sdk/CommandExecutor'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
HttpProvider = require '../backend/sdk/HttpProvider'
HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "AdCommand", ->
	beforeEach ->
		# Injector
		@injector = new Injector [HttpProviderMock]
		@mod = @injector.get AdCommand

		# HostNameBuilder
		@hostName = @injector.get HostNameBuilder
		sinon.stub(@hostName, 'getHostWithProtocol').returns 'shit://mean-ads.io'

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
			@elements = [{} , {} , {} , {} ]

		it "be a function", -> @mod.execute.should.be.a.Function
		it "returns null if program is empty", ->
			expect @mod.execute()
			.to.equal null
		it "calls http.get", ->
			@mod.execute @program, @elements
			@http.get.calledWith 'fake-http-url'
			.should.be.ok
		it "updates the innerHtml", ->
			response = JSON.stringify ['<fake-response></fake-response>']
			@mod.execute @program, @elements
			@http.$flush response, null, null
			@elements[0].innerHTML.should.equal '<fake-response></fake-response>'

	describe "_getUrl()", ->
		it "creates query params with both p and k", ->
			@mod._getUrl 'abc', ['a','b', 'c']
			.should.equal 'shit://mean-ads.io/api/v1/dispatch/abc?k=a&k=b&k=c&l=1'
		it "creates query params with only p", ->
			@mod._getUrl 'abc'
			.should.equal 'shit://mean-ads.io/api/v1/dispatch/abc?l=1'
