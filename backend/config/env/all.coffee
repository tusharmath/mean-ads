path = require 'path'

rootPath = path.normalize __dirname + '/../../..'
module.exports =
	resources: [
		'Campaign'
		'Dispatch'
		'Program'
		'Style'
		'Subscription'
	]
	bugsnag: {}
	appName: 'mean-ads'
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
	newrelic: {}