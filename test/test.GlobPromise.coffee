GlobPromise = require '../backend/modules/GlobPromise'
GlobProviderMock = require './mocks/GlobProviderMock'
GlobProvider = require '../backend/providers/GlobProvider'
Mock = require './mocks'
{Injector} = require 'di'


describe 'GlobPromise:', ->
	beforeEach ->
		@injector = new Injector Mock
		@mod = @injector.get GlobPromise
		@glob = @injector.get GlobProvider

	it 'resolves', ->
		@glob.glob = (p,o, c)-> c null, 'aaa'
		@mod.glob 'pqr', a:1
		.should.eventually.become 'aaa'

	it 'rejects', ->
		@glob.glob = (p,o, c)-> c new Error 'aaa'
		@mod.glob 'pqr', a:1
		.should.be.rejectedWith 'aaa'

