'use strict';

path = require 'path'

rootPath = path.normalize __dirname + '/../../..'

module.exports =
	root: rootPath
	cache: maxAge: 7 * 24 * 60 * 60 #7 Days
	port: process.env.PORT || 3000
	mongo:
		options:
			db:
				safe: true
