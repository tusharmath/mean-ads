{annotate, Injector, Inject} = require 'di'
class CommandExecutor
	constructor: (@injector) ->
		@_executables = {}
	register: (Command) ->
		cmd = @injector.get Command
		@_executables[cmd.alias] = cmd
	execute: (alias, args) ->
		@_executables[alias]?.execute? args...

annotate CommandExecutor, new Inject Injector
module.exports = CommandExecutor
