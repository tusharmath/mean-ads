{Provide} = require 'di'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	createConnection: -> @
	on: ->
MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
