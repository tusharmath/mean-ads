# {annotate, ClassProvider} = require 'di'
class CommandExecutor
	constructor: ->
		@_executables = {}
	register: (cmd) ->
		throw new Error 'Alias not found dude!' if not cmd.alias
		@_executables[cmd.alias] = cmd
	execute: (alias, args) ->
		@_executables[alias]?.execute? args...
# annotate CommandExecutor, new ClassProvider()
module.exports = CommandExecutor
