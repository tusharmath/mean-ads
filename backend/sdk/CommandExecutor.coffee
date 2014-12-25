class CommandExecutor
	constructor: ->
		@_executables = {}
	register: (commandName, action) ->
		@_executables[commandName] = action
	execute: (commandName, args) ->
		@_executables[commandName]?.execute? args...
module.exports = CommandExecutor
