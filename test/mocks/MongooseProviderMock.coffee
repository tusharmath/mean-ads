mockgoose = require 'mockgoose'
mongooseQ = require 'mongoose-q'
mongoose = require 'mongoose'
{Provide} = require 'di'
MongooseProvider = require '../../backend/providers/MongooseProvider'
class MongooseProviderMock
	mongoose: mongooseQ mockgoose mongoose
MongooseProviderMock.annotations = [ new Provide MongooseProvider]

module.exports = MongooseProviderMock
