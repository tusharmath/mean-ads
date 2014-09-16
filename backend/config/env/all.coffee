'use strict';

path = require 'path'

rootPath = path.normalize __dirname + '/../../..'

module.exports =
	root: rootPath
	cache: maxAge: 365 * 24 * 60 * 60 #365 Days
	port: process.env.PORT || 3000
	mongo:
		options:
			db:
				safe: true
