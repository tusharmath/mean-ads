Q = require 'q'
_ = require 'lodash'
CrudsProvider = require '../../backend/providers/CrudsProvider'
{Provide} = require 'di'

class CrudsProviderMock
	constructor: ->
		@cruds = {}
		@__contracts = {}

	# Fake method to create cruds
	__createCrud: (name, attrs) ->

		@cruds[name] = {}
		@__contracts[name] = {}
		contracts = @__contracts


		_.each attrs, (val, key) =>
			contracts[name][key] = Q val
			@cruds[name][key] = -> contracts[name][key]
			sinon.spy @cruds[name], key
		contracts

CrudsProviderMock.annotations = [
	new Provide CrudsProvider
]

module.exports = CrudsProviderMock