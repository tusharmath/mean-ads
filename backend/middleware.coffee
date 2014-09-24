coffeeMiddleware = require 'coffee-middleware'
config = require './config/config'
express = require 'express'
favicon = require 'static-favicon'
jwt = require 'express-jwt'
path = require 'path'
path = require 'path'
stylus = require 'stylus'

jwtCheck = jwt(
	secret: new Buffer config.jwt.secret, 'base64'
	audience: config.jwt.clientId
)

exports.auth = (req, res, next) ->
	_next = (err) ->
		return do next if req.user
		res
		.status 401
		.send err
	jwtCheck req, res, _next

exports.coffeescript = coffeeMiddleware(
	compress: config.coffeeCompress
	src: path.join config.root, 'frontend'
)


exports.stylus = stylus.middleware(
	force: config.stylus.forceCompile
	src: path.join config.root, 'frontend/stylus'
	dest: path.join config.root, 'frontend/css'
)


#Send Partial, or 404
exports.partials = (req, res) ->
	stripped = req.url.split('.')[0]

	requestedView = path.join './', stripped
	# console.log requestedView
	res.render requestedView, (err, html) ->
		if err
			console.log "Error rendering partial #{requestedView}\n", err
			res.render '404'
		else
			res.send html

#send our single page app
exports.page = (page) ->
	(req, res) -> res.render page
