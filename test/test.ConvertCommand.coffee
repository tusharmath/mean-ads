ConvertCommand = require '../backend/sdk/ConvertCommand'
CommandExecutor = require '../backend/sdk/CommandExecutor'
HostNameBuilder = require '../backend/sdk/HostNameBuilder'
HttpProvider = require '../backend/providers/HttpProvider'
HttpProviderMock = require './mocks/HttpProviderMock'
CreateImageElement = require '../backend/sdk/CreateImageElement'
{Injector} = require 'di'

describe "ConvertCommand", ->
	beforeEach ->
		@injector = new Injector [HttpProviderMock]
		# Convert Command
		@mod = @injector.get ConvertCommand

		# HostName
		@hostName = @injector.get HostNameBuilder
		sinon.stub(@hostName, 'getHostWithProtocol').returns 'shit://mean-ads.io'

		# CreateImageElement
		@img = @injector.get CreateImageElement
		sinon.stub @img, 'create'

		# HttpProvider
		@http = @injector.get HttpProvider
		sinon.spy @http, 'get'

		# CommandExecutor
		@exec = @injector.get CommandExecutor

	describe "constructor()", ->
		it "should register on cmdexec", ->
			@exec._executables['convert'].should.exist

	describe "execute()", ->
		beforeEach ->
			@subscriptionId = 'YGjrB1ObFS'
			sinon.stub @mod, '_getUrl'
			.returns 'fake-http-url'

		it "be a function", -> @mod.execute.should.be.a.Function
		it "returns null if program is empty",  ->
			expect @mod.execute()
			.to.equal null


		it "calls http.get",  ->
			@mod.execute @subscriptionId
			@img.create.calledWith 'fake-http-url'
			.should.be.ok

	describe "_getUrl()", ->
		it "creates query params with both p and k", ->
			@mod._getUrl 1000
			.should.equal 'shit://mean-ads.io/api/v1/subscription/1000/convert.gif'