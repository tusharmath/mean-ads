config = require './config/config'
jwt = require 'express-jwt'

jwtCheck = jwt(
	secret: new Buffer config.jwt.secret, 'base64'
	audience: config.jwt.clientId
)

module.exports =
	#Protect routes on your api from unauthenticated access
	auth: (req, res, next) ->
		_next = (err) ->
			return do next if req.user
			res
			.status 401
			.send err
		jwtCheck req, res, _next
