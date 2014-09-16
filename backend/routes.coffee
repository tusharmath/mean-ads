'use strict'
index = require './modules'
middleware = require './middleware'
api = require './routers/api'
bodyParser = require 'body-parser'
module.exports = (app) ->
		app.route('/templates/*').get index.partials
		app.route('/').get middleware.setUserCookie, index.index
		app.use '/api', bodyParser.json()
		app.use '/api/v1', (injector.get api).router
		app.route('*').all (req, res) ->
				res
				.status 404
				.render '404'
