Q = require 'q'
_ = require 'lodash'
CrudsProvider = require '../../backend/providers/CrudsProvider'
{Provide} = require 'di'

class CrudsProviderMock
	constructor: ->
		@cruds = {}
	# Fake method to create cruds
	__createCrud: (name, actions) ->
		@cruds[name] = {}

CrudsProviderMock.annotations = [
	new Provide CrudsProvider
]

module.exports = CrudsProviderMock