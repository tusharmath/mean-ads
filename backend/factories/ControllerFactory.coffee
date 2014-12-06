{Inject, Injector, annotate} = require 'di'
_ = require 'lodash'
class ControllerFactory
	controllers: [
		'Campaign'
		'Dispatch'
		'Program'
		'Style'
		'Subscription'
	]
	constructor: (injector) ->
		@Controllers = {}
	 _.map @controllers, (i) =>
	 	@Controllers[i] = injector.get require "../controllers/#{i}Controller"
annotate ControllerFactory, new Inject Injector

module.exports = ControllerFactory
