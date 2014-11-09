path = require 'path'

rootPath = path.normalize __dirname + '/../../..'
module.exports =
	Q: longStackSupport: true
	root: rootPath
	cache:
		maxAge: 365 * 24 * 60 * 60 #365 Days
		dir: rootPath + '/.cache'
	port: process.env.PORT || 3000
	mongo:
		options:
			db:
				safe: true
