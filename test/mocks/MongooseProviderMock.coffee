{Provide} = require 'di'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	mongoose: 'i am so fake'
MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
