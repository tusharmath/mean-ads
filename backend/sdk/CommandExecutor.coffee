class CommandExecutor
	constructor: ->
		@_executables = {}
	register: (commandName, action) ->
		@_executables[commandName] = action
	execute: (commandName, args) ->
		if not @_executables[commandName]
			throw new Error "#{commandName} is not registered"
		@_executables[commandName].execute? args...
module.exports = CommandExecutor
