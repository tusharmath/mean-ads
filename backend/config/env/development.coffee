'use strict'

module.exports =
	stylus: forceCompile: true
	bragi:
		options:
			groupsEnabled: true
	env: 'development'
	ip: '0.0.0.0'
	coffeeCompress: false
	mongo:
		uri: 'mongodb://root:1234567890@kahana.mongohq.com:10062/adwords'
