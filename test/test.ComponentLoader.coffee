ComponentLoader = require '../backend/modules/ComponentLoader'
GlobProvider = require '../backend/providers/GlobProvider'
Mocks = require './mocks'
{Injector} = require 'di'
should = require 'should'

describe 'ComponentLoader:', ->
	[mod, glob] = 0
	beforeEach ->
		injector = new Injector Mocks
		mod = injector.get ComponentLoader
		glob = injector.get GlobProvider

	describe "load()", ->
		it "returns promise", ->
			glob.$expect '*Crud.coffee', cwd: './backend/cruds'
			mod.load('crud').then.should.be.a.Function

		it 'resolves components', (done) ->
			glob.$expect '*Crud.coffee', cwd: './backend/cruds', null, ['aaCrud.coffee', 'BbCrud.coffee']
			mod.load('crud').done (_cruds) ->
				_cruds.should.eql
					aa: '../cruds/aaCrud.coffee-required'
					Bb: '../cruds/BbCrud.coffee-required'

				done()
			glob.$flush()

