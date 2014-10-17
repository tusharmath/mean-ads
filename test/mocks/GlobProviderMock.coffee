{Provide} = require 'di'
_ = require 'lodash'
GlobProvider = require '../../backend/providers/GlobProvider'

class GlobProviderMock
	constructor: ->
		@_keyCollection = []
	glob:  sinon.spy (pattern, options, callback) ->
		expectation = _.find @_keyCollection, (val, key) ->
			val.p is pattern and val.o is options
		if not expectation
			throw new Error "$expect should be set for pattern: #{pattern} and options: #{JSON.stringify options}"
		expectation.c = callback

	$expect: (p, o, _args...) ->
		if (_.any @_keyCollection, (v,k)-> v.p is p and v.o is o)
			throw new Error "Expectaions already set for Pattern: #{p} and Options: #{JSON.stringify o}"
		@_keyCollection.push {p,o,_args}

	$flush: ->
		_.each @_keyCollection, (val, key) ->
			{c, _args, p} = val
			if not c
				throw new Error "glob should be called first for: #{p}"
			if typeof c isnt 'function'
				throw new Error "Cmon dude! pass a function callback for: #{p}"
			c.apply null, _args
		@_keyCollection = []

GlobProviderMock.annotations = [
	new Provide GlobProvider
]

module.exports = GlobProviderMock
