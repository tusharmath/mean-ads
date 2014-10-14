_ = require 'lodash'
q = require 'q'
GlobProvider = require './GlobProvider'
{Inject} = require 'di'
# TODO: Can be used at other places
ctorCase = (str) -> str.replace /.?/, str[0].toUpperCase()
# TODO: Util function
resourceName = (type, file) ->
	type = ctorCase type
	file.replace "#{type}.coffee", ''

class ComponentLoader
	constructor: (@glob) ->
	_loadFiles: (type, callback) ->
		globOptions =
			cwd: "./backend/#{type}s"
		type = ctorCase type
		@glob "*#{type}.coffee", globOptions, callback


	load: (type, ignored = []) ->
		compColl = {}
		defer = q.defer()
		@_loadFiles type, (err, componentFiles) ->
			return defer.reject err if err
			_.each componentFiles, (file) ->

				if (_.contains ignored, file) is false
					component = require "../#{type}s/#{file}"
					compName = resourceName type, file
					compColl[compName] = require "../#{type}s/#{file}"
			defer.resolve compColl
		defer.promise

ComponentLoader.annotations = [
	new Inject GlobProvider
]
module.exports = ComponentLoader
