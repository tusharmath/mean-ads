path = require 'path'

rootPath = path.normalize __dirname + '/../../..'
module.exports =
	maxDispatchStampCount: 4
	conversionMaxAge: 5 * 60 * 1000 #5 Mins (in ms)
	resources: [
		'Campaign'
		'Dispatch'
		'Program'
		'Style'
		'Subscription'
	]
	bugsnag: notify: false
	appName: 'mean ads'
	Q: longStackSupport: true
	root: rootPath
	cache:
		maxAge: 365 * 24 * 60 * 60 #365 Days (in sec)
		dir: rootPath + '/.cache'
	port: process.env.PORT || 3000
	mongo:
		options:
			db:
				safe: true
	newrelic: {}