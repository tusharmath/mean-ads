'use strict'
module.exports =
	redis:
		uri: 'tcp://localhost:6379'
	mongo:
		uri: 'mongodb://localhost:27017/adwords'
	bragi:
		options:
			groupsEnabled: ['application']
	env: 'development'
	newrelic: enabled: false
	appHost: 'localhost:3000'