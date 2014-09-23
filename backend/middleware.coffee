config = require './config/config'
module.exports =
	#Protect routes on your api from unauthenticated access
	auth: (req, res, next) ->
		return next() if req.isAuthenticated()
		res.send 401

	#Set a cookie for angular so it knows we have an http session
	cors: (req, res, next) ->
		cors = [
			"https://#{config.jwt.domain}"
			"http://#{config.jwt.domain}"
		]
		res.header "Access-Control-Allow-Origin", cors.join()
		res.header "Access-Control-Allow-Headers", "X-Requested-With"
		next()
