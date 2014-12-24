path = require 'path'

rootPath = path.normalize __dirname + '/../../..'
module.exports =
	mailgun:
		login: 'postmaster@meanads.com'
		domain: 'meanads.com'
		noReplyEmail: 'noreply@meanads.com'
	maxDispatchStampCount: 4
	conversionMaxAge: 5 * 60 * 1000 #5 Mins (in ms)
	resources: [
		'Campaign'
		'Dispatch'
		'Program'
		'Style'
		'Subscription'
	]
	appName: 'mean ads'
	Q: longStackSupport: true
	root: rootPath
	cache:
		maxAge: 60 * 60 #1 Hour (in sec)
		dir: rootPath + '/.cache'
	port: process.env.PORT || 3000
	mongo:
		options:
			db:
				safe: true
	newrelic: notify: false