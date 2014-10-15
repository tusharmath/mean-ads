{Provide} = require 'di'
GlobProvider = require '../../backend/providers/GlobProvider'
class GlobProviderMock
	glob: (pattern, obj, callback) -> callback ['a', 'b', 'c']

GlobProviderMock.annotations = [
	new Provide GlobProvider
]

module.exports = GlobProviderMock
