{annotate, Inject, ClassProvider} = require 'di'
CommandExecutor = require './CommandExecutor'
WindowProvider = require '../providers/WindowProvider'
HostNameBuilder = require './HostNameBuilder'

class Main
	constructor: (@exec, @windowP, @host) ->

	# command: string, args: Array
	ma : (command, args...) =>
		@exec.execute command, args
	setup: ->

		window = @windowP.window()

		if window.ma
			# Setup host
			@host.setup()
			# execute queue commands
			if window.ma.q
				for savedArgs in window.ma.q
					[cmd, arg2...]  = savedArgs
					@ma cmd, arg2...

		# # Override the original ma
		window.ma = @ma


annotate Main, new Inject(
	# Actual Deps
	CommandExecutor
	WindowProvider
	HostNameBuilder
	# Loading Commands
	require './AdCommand'
	require './ConvertCommand'
	)
annotate Main, new ClassProvider

module.exports = Main