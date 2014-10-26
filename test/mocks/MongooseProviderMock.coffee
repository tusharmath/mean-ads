{Provide} = require 'di'
mockgoose = require 'mockgoose'
mongoose = require 'mongoose'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	constructor: ->
		@mongoose = mongoose

MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
