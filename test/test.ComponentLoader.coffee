ComponentLoader = require '../backend/modules/ComponentLoader'
Mocks = require './mocks'
{Injector} = require 'di'
# describe 'ComponentLoader', ->
# 	testable = injector = {}
# 	beforeEach ->
# 		injector = new Injector Mocks
# 		testable = injector.get ComponentLoader

# 	describe "constructor", ->

# 		it 'should use mock require',
# 		->	testable.requireProvider.require('xyz').should.equal 'xyz-module'

# 		it 'should use mock glob', (async)->
# 			testable.globProvider.glob no, no,
# 			(res)->
# 				res.should.eql ['a', 'b', 'c']
# 				do async
