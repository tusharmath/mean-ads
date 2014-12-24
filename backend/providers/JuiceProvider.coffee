juice = require 'Juice'
Q = require 'q'
class JuiceProvider
	juiceContentQ: (markup, options) ->
		Q.Promise (resolve, reject) ->
			juice.juiceContent markup, options, (err, html) ->
				return reject err if err
				resolve html


module.exports = JuiceProvider