_ = require 'lodash'
glob = require 'glob'

# TODO: Can be used at other places
ctorCase = (str) -> str.replace /.?/, str[0].toUpperCase()
# TODO: Util function
resourceName = (type, file) ->
	type = ctorCase type
	file.replace "#{type}.coffee", ''



class ComponentLoader

	_loadFiles: (type) ->
		globOptions =
			cwd: "./backend/#{type}s"
			sync: true #TODO: Make it unsync
		type = ctorCase type
		glob "*#{type}.coffee", globOptions


	load: (type, ignored = []) ->
		compColl = {}
		componentFiles = @_loadFiles type

		_.each componentFiles, (file) ->
			console.log file
			component = require "../#{type}s/#{file}"
			compName = resourceName type, file
			compColl[compName] = require "../#{type}s/#{file}"
		compColl

module.exports = ComponentLoader
