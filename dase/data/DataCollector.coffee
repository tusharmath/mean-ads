{annotate, Inject} = require 'di'
class DataCollector
	constructor: ->
annotate DataCollector, new Inject(require '../backend/factories/ModelFactory')
module.exports = DataCollector