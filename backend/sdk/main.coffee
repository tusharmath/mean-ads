{annotate, Inject} = require 'di'
CommandExecutor = require './CommandExecutor'
WindowProvider = require '../providers/WindowProvider'

class Main
	constructor: (@exec, @windowP) ->
	setup: ->
		{ma} = @windowP.window()


injecteds = new Inject(
	# Actual Deps
	CommandExecutor
	WindowProvider

	# Loading Commands
	require './AdCommand'
	require './ConvertCommand'
	)
annotate Main, injecteds
module.exports = Main