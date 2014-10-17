{Provide} = require 'di'
_ = require 'lodash'
GlobProvider = require '../../backend/providers/GlobProvider'

class GlobProviderMock
	constructor: ->
		@_keyCollection = []
	glob:  sinon.spy (pattern, options, callback) ->
		expectation = _.find @_keyCollection, (val, key) -> val.p is pattern
		if not expectation
			throw new Error "$expect should be set for pattern: #{pattern}"
		expectation.c = callback

	$expect: (p, _args...) ->
		if (_.any @_keyCollection, (v,k)-> v.p is p)
			throw new Error "Pattern already set: #{p}"
		@_keyCollection.push {p,_args}

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
