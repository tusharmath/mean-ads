{Provide} = require 'di'

GlobProvider = require '../../backend/providers/GlobProvider'
class GlobProviderMock
	glob: (pattern, obj, callback) -> callback ['a', 'b', 'c']

GlobProviderMock.annotations = [
	new Provide GlobProvider
]

MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	mongoose: 'i am so fake'
MongooseProviderMock.annotations = [ new Provide MongooseProvider]

RequireProvider = require '../../backend/providers/RequireProvider'
class RequireProviderMock
	require: (pattern) ->return "#{pattern}-module"

RequireProviderMock.annotations = [
	new Provide RequireProvider
]

module.exports = [GlobProviderMock, MongooseProviderMock, RequireProviderMock]
