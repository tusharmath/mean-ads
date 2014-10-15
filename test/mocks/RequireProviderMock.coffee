{Provide} = require 'di'
RequireProvider = require '../../backend/providers/RequireProvider'
class RequireProviderMock
	require: (pattern) ->return "#{pattern}-module"

RequireProviderMock.annotations = [
	new Provide RequireProvider
]

module.exports = RequireProviderMock
