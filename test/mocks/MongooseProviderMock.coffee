{Provide} = require 'di'
mockgoose = require 'mockgoose'
mongooseQ = require 'mongoose-q'
mongoose = require 'mongoose'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	constructor: ->
		@mongoose = mongooseQ mockgoose mongoose
	reset: ->
		# Resetting models
		mongoose.models = {}
		mockgoose.reset()

MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
