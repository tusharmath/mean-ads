juice = require 'juice'
config = require '../config/config'
Q = require 'q'
class JuiceProvider
	constructor: ->
		@options = url: "http://localhost:#{config.port}"
	juiceContentQ: (markup) ->
		Q.Promise (resolve, reject) =>
			juice.juiceContent markup, @options, (err, html) ->
				return reject err if err
				resolve html


module.exports = JuiceProvider