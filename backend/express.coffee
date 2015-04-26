config = require './config/config'
express = require 'express'
newrelic = require 'newrelic'
packageFile = require '../package.json'
humanize = require 'humanize'
bragi = require 'bragi'

# Middlewares
middleware = require './middleware'
path = require 'path'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'

#TODO: Have one. Env Specific configs
prod = require './config/express-prod'
dev = require './config/express-dev'

class V1
	constructor: (api) ->
		v1 = api.router()
		app = express()
		app.locals.newrelic = newrelic
		app.locals.package = packageFile
		app.locals.config = config
		# TODO: Being used in mailer also
		app.locals.humanize = humanize

		app
		.set 'views', "#{config.root}/frontend"
		.set 'view engine', 'jade'

		env = app.get 'env'

		dev app if env is 'development'
		prod app if env is 'production'


		app
		# Middlewares
		.use cookieParser config.cookie.secret
		.use '/static', [
			middleware.coffeescript
			middleware.stylus
			express.static path.join(config.root, 'frontend')
		]

		# Only Core must be authenticated
		.use '/api/v1/core', [
			middleware.auth
		]
		.use '/api/v1/dispatch', [
			middleware.uuid
		]
		.use '/api/v1', [
			bodyParser.json()
			v1
		]
		# Routes
		.get "/templates/*", middleware.partials
		.get '/', middleware.page 'index'
		.all '/*', middleware.page '404'

		# Start server
		app.listen config.port, config.ip, ->
			bragi.log 'application', bragi.util.symbols.success, 'Server Started', bragi.util.print("#{config.ip}:#{config.port}", 'yellow'), 'in', bragi.util.print("#{app.get 'env'}", 'yellow'), 'mode'

module.exports = V1
