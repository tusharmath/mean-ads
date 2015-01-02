#!/usr/bin/env coffee

###
Git COMMIT-MSG hook for validating commit message
See https://docs.google.com/document/d/1rk04jEuGfk9kYzfqCuOlPTSJw3hEDZJTBN5E5f1SALo/edit

Installation:
>> ln -s ../../validate-commit-msg.coffee .git/hooks/commit-msg
###
"use strict"
fs = require("fs")
util = require("util")
MAX_LENGTH = 100
PATTERN = /^(?:fixup!\s*)?(\w*)(\(([\w\$\.\*/-]*)\))?\: (.*)$/
IGNORED = /^WIP\:/
TYPES =
	feat: true
	fix: true
	docs: true
	style: true
	refactor: true
	perf: true
	test: true
	chore: true
	revert: true

error = ->

	# gitx does not display it
	# http://gitx.lighthouseapp.com/projects/17830/tickets/294-feature-display-hook-error-message-when-hook-fails
	# https://groups.google.com/group/gitx/browse_thread/thread/a03bcab60844b812
	console.error "INVALID COMMIT MSG: " + util.format.apply(null, arguments)
	return

validateMessage = (message) ->
	isValid = true
	if IGNORED.test(message)
		console.log "Commit message validation ignored."
		return true
	if message.length > MAX_LENGTH
		error "is longer than %d characters !", MAX_LENGTH
		isValid = false
	match = PATTERN.exec(message)
	unless match
		error "does not match \"<type>(<scope>): <subject>\" ! was: " + message
		return false
	type = match[1]
	scope = match[3]
	subject = match[4]
	unless TYPES.hasOwnProperty(type)
		error "\"%s\" is not allowed type !", type
		return false

	# Some more ideas, do want anything like this ?
	# - allow only specific scopes (eg. fix(docs) should not be allowed ?
	# - auto correct the type to lower case ?
	# - auto correct first letter of the subject to lower case ?
	# - auto add empty line after subject ?
	# - auto remove empty () ?
	# - auto correct typos in type ?
	# - store incorrect messages, so that we can learn
	isValid

firstLineFromBuffer = (buffer) ->
	buffer.toString().split("\n").shift()


# publish for testing
exports.validateMessage = validateMessage

# hacky start if not run by jasmine :-D
if process.argv.join("").indexOf("jasmine-node") is -1
	commitMsgFile = process.argv[2]
	incorrectLogFile = commitMsgFile.replace("COMMIT_EDITMSG", "logs/incorrect-commit-msgs")
	fs.readFile commitMsgFile, (err, buffer) ->
		msg = firstLineFromBuffer(buffer)
		unless validateMessage(msg)
			fs.appendFile incorrectLogFile, msg + "\n", ->
				process.exit 1
				return

		else
			process.exit 0
		return
