HttpProviderMock = require './mocks/HttpProviderMock'
{Injector} = require 'di'

describe "AdCommand", ->
	beforeEach ->
		# Injector
		@injector = new Injector [HttpProviderMock]
		@mod = @injector.getModule 'sdk.AdCommand', mock: false

		# HostNameBuilder
		@hostName = @injector.getModule 'sdk.HostNameBuilder'
		@hostName.getHostWithProtocol.returns 'shit://mean-ads.io'

		# HttpProvider
		@http = @injector.getModule 'sdk.HttpProvider', mock: false
		sinon.spy @http, 'get'

		# CommandExecutor
		@exec = @injector.getModule 'sdk.CommandExecutor', mock: false

	describe "constructor()", ->
		it "should register on cmdexec", ->
			@exec._executables['ad'].should.exist

	describe "execute()", ->
		beforeEach ->
			sinon.stub @mod, '_getUrl'
			.returns 'fake-http-url'
			@program = 102
			@elements = [{} , {} , {} , {} ]
			@response = JSON.stringify ['<fake-response></fake-response>']

		it "be a function", -> @mod.execute.should.be.a.Function
		it "returns null if program is empty", ->
			expect @mod.execute()
			.to.equal null
		it "calls http.get", ->
			@mod.execute @program, @elements
			@http.get.calledWith 'fake-http-url'
			.should.be.ok
		it "updates the innerHtml", ->
			@mod.execute @program, @elements
			@http.$flush @response, null, null
			@elements[0].innerHTML.should.equal '<fake-response></fake-response>'
		it "handles non array elements", ->
			@mod.execute @program, el = {}
			@http.$flush @response, null, null
			el.innerHTML.should.equal '<fake-response></fake-response>'

	describe "_getUrl()", ->
		it "creates query params with both p and k", ->
			@mod._getUrl 'abc', ['a','b', 'c']
			.should.equal 'shit://mean-ads.io/api/v1/dispatch/abc?k=a&k=b&k=c&l=1'
		it "creates query params with only p", ->
			@mod._getUrl 'abc'
			.should.equal 'shit://mean-ads.io/api/v1/dispatch/abc?l=1'
