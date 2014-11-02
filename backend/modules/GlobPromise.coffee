{Inject} = require 'di'
Q = require 'q'
GlobProvider = require '../providers/GlobProvider'
class GlobPromise
	constructor: (@globProvider) ->
	glob: (pattern, options) ->
		Q.Promise (resolve, reject) =>
			@globProvider.glob pattern, options, (err, files) ->
				return reject err if err instanceof Error
				resolve files

GlobPromise.annotations = [new Inject GlobProvider]

module.exports = GlobPromise
