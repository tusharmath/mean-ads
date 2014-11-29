ComponentLoader = require '../modules/ComponentLoader'
BaseCtrl = require '../controllers/BaseController'
{Inject, Injector, annotate} = require 'di'
_ = require 'lodash'
class ControllerFactory
	constructor: (@loader, @injector) ->

	init: ->
		@loader.load 'controller', ['BaseController.coffee']
		.then @_onLoad
	_extend: (base,child) ->
		[_proto, child::] = [child::, base]
		_.assign child::, _proto

		child::_base = {}
		_.assign child::_base, base

	_onLoad: (ctrls) =>
		controllers = {}
		_.each ctrls, (ctrlCtor, ctrlName) =>
			bragi.log 'controller', ctrlName
			# Settingup BaseController
			baseCtrl = @injector.get BaseCtrl
			baseCtrl.resourceName = ctrlName

			@_extend baseCtrl, ctrlCtor

			controllers[ctrlName] = @injector.get ctrlCtor
		controllers

annotate ControllerFactory, new Inject ComponentLoader, Injector

module.exports = ControllerFactory
