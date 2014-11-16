#TODO: Stupid Approach, It sucks!
class ModelsProvider
	constructor: ->
		models = null
		get = ->
			if not models
				throw new Error 'Models have not been initialized!'
			models

		set = (_models) ->
			models = _models
			bragi.log 'models', 'Models Initialized Successfully'
		Object.defineProperty @, 'models', {get, set}
module.exports = ModelsProvider
