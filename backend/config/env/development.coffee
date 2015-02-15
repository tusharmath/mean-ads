'use strict'

module.exports =
	browserify:
		debug: true
	mailgun:
		apiKey: 'key-57091db7c8d6a4b0d557a34a3b9b63e9'
		password: 'ba45f8a7af2a503c7cc2e436f38c0f9e'
	cookie: secret: "TO363ca3Wej4has"
	jwt:
		secret: 'G3AEzjlLJ6Fzk2IiOdwgtrOcfa4jgmUYLiB22PnFtg_D6f3ACv541EqRs5heYDhK'
		clientId: '6zvBZ3dG9XJl8zre9bCpPNTTxozUShX7'
		domain: 'mean-ads.auth0.com'
	stylus: forceCompile: true
	bragi:
		options:
			groupsEnabled: true
	env: 'development'
	ip: '0.0.0.0'
	coffeeCompress: false
	mongo:
		uri: 'mongodb://root:1234567890@kahana.mongohq.com:10062/adwords'
	newrelic:
		license: 'no-license'
		enabled: false
	appHost: 'localhost:3000'