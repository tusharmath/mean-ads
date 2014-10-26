class CrudsProvider
	constructor: ->
		cruds = null
		get = ->
			if not cruds
				throw new Error 'cruds have not been initialized!'
			cruds

		set = (_cruds) ->
			cruds = _cruds
			bragi.log 'cruds', 'cruds Initialized Successfully'
		Object.defineProperty @, 'cruds', {get, set}
module.exports = CrudsProvider
