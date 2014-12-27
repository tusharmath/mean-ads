WindowProvider = require '../providers/WindowProvider'
{annotate, Inject} = require 'di'

class CreateImageElement
	constructor: (@windowP) ->
	create: (url, callback) ->
		{document} = @windowP.window()
		img = document.createElement 'img'
		img.src = url
		img.onload = img.onerror = ->
			img.onload = img.onerror = null
			callback() if callback

annotate CreateImageElement, new Inject WindowProvider
module.exports = CreateImageElement