ConvertCommand = require '../backend/sdk/ConvertCommand'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
HttpProvider = require '../backend/providers/HttpProvider'
HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "ConvertCommand", ->
	beforeEach ->
		@injector = new Injector [HttpProviderMock]
		@mod = @injector.get ConvertCommand
		@hostName = @injector.get HostNameBuilder
		sinon.stub @hostName, 'getHost'
		.returns 'mean-ads.io'
		@http = @injector.get HttpProvider
		sinon.spy @http, 'get'

	describe "execute()", ->
		beforeEach ->
			@subscriptionId = 'YGjrB1ObFS'
			sinon.stub @mod, '_getUrl'
			.returns 'fake-http-url'
			sinon.spy @mod, 'callback'

		it "be a function", -> @mod.execute.should.be.a.Function
		it "returns null if program is empty",  ->
			expect @mod.execute()
			.to.equal null
		it "calls http.get",  ->
			@mod.execute @subscriptionId
			@http.get.calledWith 'fake-http-url', @mod.callback
			.should.be.ok
		it "calls the callback with response", ->
			@mod.execute @subscriptionId
			@http.$flush '<fake-response></fake-response>'
			@mod.callback.calledWith '<fake-response></fake-response>'
			.should.be.ok

	describe "_getUrl()", ->
		it "creates query params with both p and k", ->
			@mod._getUrl 1000
			.should.equal '//mean-ads.io/api/v1/subscription/1000/convert'