_ = require 'lodash'
glob = require 'glob'
q = require 'q'
# TODO: Can be used at other places
ctorCase = (str) -> str.replace /.?/, str[0].toUpperCase()
# TODO: Util function
resourceName = (type, file) ->
	type = ctorCase type
	file.replace "#{type}.coffee", ''



class ComponentLoader

	_loadFiles: (type, callback) ->
		globOptions =
			cwd: "./backend/#{type}s"
		type = ctorCase type
		glob "*#{type}.coffee", globOptions, callback


	load: (type, ignored = []) ->
		compColl = {}
		defer = q.defer()
		@_loadFiles type, (err, componentFiles) ->
			return defer.reject err if err
			_.each componentFiles, (file) ->
				if ignored.indexOf file is - 1
					component = require "../#{type}s/#{file}"
					compName = resourceName type, file
					compColl[compName] = require "../#{type}s/#{file}"
			defer.resolve compColl
		defer.promise

module.exports = ComponentLoader
