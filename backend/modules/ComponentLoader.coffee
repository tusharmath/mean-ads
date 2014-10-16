_ = require 'lodash'
q = require 'q'
RequireProvider = require '../providers/RequireProvider'
GlobPromise = require './GlobPromise'
{Inject} = require 'di'

# TODO: Can be used at other places
ctorCase = (str) -> str.replace /.?/, str[0].toUpperCase()
resourceName = (type, file) ->
	type = ctorCase type
	file.replace "#{type}.coffee", ''

class ComponentLoader
	constructor: (@globPromise, @requireProvider) ->

	_glob: (type) ->
		options = cwd: "./backend/#{type}s"
		pattern = "*#{ctorCase type}.coffee"
		@globPromise.glob pattern, options

	_onLoad: (type, ignored, files) =>
		compColl = {}
		_require = @requireProvider.require
		_.each files, (file) ->
			if (_.contains ignored, file) is false
				component = _require "../#{type}s/#{file}"
				compName = resourceName type, file
				compColl[compName] = component
		compColl

	load: (type, ignored = []) ->
		@_glob type
		.then _.curry(@_onLoad, 3) type, ignored


ComponentLoader.annotations = [
	new Inject GlobPromise, RequireProvider
]
module.exports = ComponentLoader
