AdCommand = require '../backend/sdk/AdCommand'
HttpProvider = require '../backend/providers/HttpProvider'
HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "AdCommand", ->
	beforeEach ->
		@injector = new Injector [HttpProviderMock]
		@mod = @injector.get AdCommand
		@http = @injector.get HttpProvider
		sinon.spy @http, 'get'

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
			.should.equal '/api/v1/dispatch/ad?p=abc&k=a&k=b&k=c'
		it "creates query params with only p", ->
			@mod._getUrl 'abc'
			.should.equal '/api/v1/dispatch/ad?p=abc'