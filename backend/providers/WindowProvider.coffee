{ClassProvider, annotate} = require 'di'
# Provides the global window object
class WindowProvider
	window: ->	window
annotate WindowProvider, new ClassProvider
module.exports = WindowProvider