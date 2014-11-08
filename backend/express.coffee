config = require './config/config'
dev = require './config/express-dev'
express = require 'express'
middleware = require './middleware'
path = require 'path'
prod = require './config/express-prod'
bodyParser = require 'body-parser'
api = require './modules/RouteResolver'
di = require 'di'
class V1
	constructor: (api) ->
		api
		.init()
		.done (v1) ->
			app = express()

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
				v1
			]
			#Routes
			.get '/templates/*', middleware.partials
			.get '/', middleware.page 'index'
			.all '/*', middleware.page '404'


			# Start server
			app.listen config.port, config.ip, ->
				bragi.log 'application', bragi.util.symbols.success, 'Server Started', bragi.util.print("#{config.ip}:#{config.port}", 'yellow'), 'in', bragi.util.print("#{app.get 'env'}", 'yellow'), 'mode'
di.annotate V1, new di.Inject api

injector = new di.Injector()
injector.get V1
