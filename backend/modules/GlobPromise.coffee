{Inject} = require 'di'
Q = require 'q'
GlobProvider = require '../providers/GlobProvider'
class GlobPromise
	constructor: (@globProvider) ->
	glob: (pattern, options) ->
		defer = Q.defer()
		@globProvider.glob pattern, options, (err, files) ->
			return defer.reject err if err instanceof Error
			defer.resolve files
		defer.promise

GlobPromise.annotations = [new Inject GlobProvider]

module.exports = GlobPromise
