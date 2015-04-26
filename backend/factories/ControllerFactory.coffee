{resources} = require '../config/config'

# TODO: Dynamically Set
ControllerNames = [
	'Campaign'
	'Dispatch'
	'Program'
	'Style'
	'Subscription'
]

_ = require 'lodash'
class ControllerFactory
	constructor: (injector) ->
		@Controllers = {}
		_.each ControllerNames, (i) =>
			@Controllers[i] = injector.get require "../controllers/#{i}Controller"
# annotate ControllerFactory, new Inject Injector

module.exports = ControllerFactory
