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
	transparentGif:
		contentType: 'image/gif'
		image: new Buffer [
    	0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00,
	    0x80, 0x00, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x2c,
	    0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02,
	    0x02, 0x44, 0x01, 0x00, 0x3b
	]