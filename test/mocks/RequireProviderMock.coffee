{Provide} = require 'di'
RequireProvider = require '../../backend/providers/RequireProvider'
class RequireProviderMock
	require:  sinon.spy()

RequireProviderMock.annotations = [
	new Provide RequireProvider
]

module.exports = RequireProviderMock
