{Inject, annotate} = require 'di'
BaseController = require './BaseController'

class StyleController
	constructor: (@actions) ->
annotate StyleController, new Inject BaseController
module.exports = StyleController
