'use strict'

module.exports =
	cookie: secret: "a71tamXSG"
	bugsnag:
		notify: true
		secret: '5508c1c51f0416834121de08cccf2034'
	env: 'production'
	jwt:
		secret: 'G3AEzjlLJ6Fzk2IiOdwgtrOcfa4jgmUYLiB22PnFtg_D6f3ACv541EqRs5heYDhK'
		clientId: '6zvBZ3dG9XJl8zre9bCpPNTTxozUShX7'
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
		uri: process.env.MONGOLAB_URI ||
			process.env.MONGOHQ_URL ||
			process.env.OPENSHIFT_MONGODB_DB_URL +
			process.env.OPENSHIFT_APP_NAME ||
			'mongodb://root:1234567890@kahana.mongohq.com:10062/adwords'
	newrelic:
		notify: true
		license: 'e6d2a6347a283cffb5d7a5f3e35e672eae9d4d06'
		enabled: true