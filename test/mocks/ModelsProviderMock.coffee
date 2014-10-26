mockgoose = require 'mockgoose'
mongooseQ = require 'mongoose-q'
mongoose = require 'mongoose'

ModelsProvider = require '../../backend/providers/ModelsProvider'
{Provide} = require 'di'
class ModelsProviderMock
	constructor: ->
		@models = {}
		@mongoose = mongooseQ mockgoose mongoose
	__createModel: (name, schemaDefinition) ->
		schema = new mongoose.Schema schemaDefinition
		@models[name] = @mongoose.model name, schema
	__reset: ->
		@mongoose.models = {}
ModelsProviderMock.annotations = [
	new Provide ModelsProvider
]

module.exports = ModelsProviderMock