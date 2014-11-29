{Provide} = require 'di'
mockgoose = require 'mockgoose'
mongooseQ = require 'mongoose-q'
mongoose = require 'mongoose'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	constructor: ->
		@mongoose = mongooseQ mockgoose mongoose
	__reset: ->
		# Resetting models
		@mongoose.models = {}
		mockgoose.reset()
	__fakeModel: (schema = {}, modelName = 'FakeModel') ->
		FakeSchema = @mongoose.Schema schema
		@mongoose.model modelName, FakeSchema

MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
