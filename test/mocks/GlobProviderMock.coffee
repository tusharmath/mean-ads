{Provide} = require 'di'
GlobProvider = require '../../backend/providers/GlobProvider'

class GlobProviderMock
	glob:  sinon.spy (p,o, @c) ->
	_resolve : (args...) ->
		@c.apply null, args

GlobProviderMock.annotations = [
	new Provide GlobProvider
]

module.exports = GlobProviderMock
