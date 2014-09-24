config = require './config/config'
dev = require './config/express-dev'
express = require 'express'
middleware = require './middleware'
path = require 'path'
prod = require './config/express-prod'
bodyParser = require 'body-parser'
api = require './routers/api'


#Global and ENV specifc settings
module.exports = (app) ->
	app
	.set 'jsonp callback name', 'mean'
	.set 'views', "#{config.root}/frontend"
	.set 'view engine', 'jade'

	env = app.get 'env'

	dev app if env is 'development'
	prod app if env is 'production'

	app
	#Middlewares
	.use '/static', [
		middleware.coffeescript
		middleware.stylus
		express.static path.join(config.root, 'frontend')
	]
	.use '/api/v1', [
		bodyParser.json()
		middleware.auth
		(injector.get api).router
	]
	#Routes
	.get '/templates/*', middleware.partials
	.get '/', middleware.page 'index'
	.all '/*', middleware.page '404'
