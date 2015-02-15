'use strict'

module.exports =
	browserify:
		debug: false
	mailgun:
		apiKey: process.env.MAILGUN_APIKEY
		password: process.env.MAILGUN_PASSWORD
	cookie: secret: process.env.COOKIE_SECRET
	env: 'production'
	jwt:
		secret: process.env.JWT_SECRET
		clientId: process.env.JWT_CLIENTID
		domain: 'mean-ads.auth0.com'
	stylus: forceCompile: false
	bragi:
		options:
			groupsEnabled: true
	coffeeCompress: true
	ip: process.env.OPENSHIFT_NODEJS_IP ||
		process.env.IP ||
		'0.0.0.0'
	port: process.env.OPENSHIFT_NODEJS_PORT ||
		process.env.PORT
	mongo:
		uri: process.env.MONGOLAB_URI
	newrelic:
		notify: true
		license: process.env.NEW_RELIC_LICENSE_KEY
		enabled: true
	appHost: process.env.APP_HOST || 'app.meanads.com'