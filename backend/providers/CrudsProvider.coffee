BaseCrud = require '../Cruds/BaseCrud'
{Injector, annotate, Inject} = require 'di'

class CrudsProvider
	constructor: (@injector) ->
	with: (resourceName) ->
		crud = @injector.get BaseCrud
		crud.resourceName = resourceName
		crud

annotate CrudsProvider, new Inject Injector
module.exports = CrudsProvider