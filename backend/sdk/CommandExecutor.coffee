{annotate, Injector, Inject} = require 'di'
class CommandExecutor
	constructor: (@injector) ->
		@_executables = {}
	register: (cmd) ->
		throw new Error 'Alias not found dude!' if not cmd.alias
		@_executables[cmd.alias] = cmd
	execute: (alias, args) ->
		@_executables[alias]?.execute? args...

annotate CommandExecutor, new Inject Injector
module.exports = CommandExecutor
