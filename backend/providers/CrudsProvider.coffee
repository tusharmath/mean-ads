BaseCrud = require '../cruds/BaseCrud'
{Injector, annotate, Inject} = require 'di'
{MeanError} = require '../config/error-codes'

class CrudsProvider
	constructor: (@injector) ->
	with: (resourceName) ->
		throw new MeanError 'resourceName has not been set' if not resourceName
		crud = @injector.get BaseCrud
		crud.resourceName = resourceName
		crud

annotate CrudsProvider, new Inject Injector
module.exports = CrudsProvider