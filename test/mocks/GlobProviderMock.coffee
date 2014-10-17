{Provide} = require 'di'
_ = require 'lodash'
GlobProvider = require '../../backend/providers/GlobProvider'

class GlobProviderMock
	constructor: ->
	glob: ->

GlobProviderMock.annotations = [
	new Provide GlobProvider
]

module.exports = GlobProviderMock
