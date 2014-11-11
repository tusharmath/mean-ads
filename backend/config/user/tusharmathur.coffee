'use strict'
module.exports =
	mongo:
		uri: 'mongodb://localhost:27017/adwords'
	bragi:
		options:
			groupsEnabled: ['application', 'api']
	env: 'development'
	newrelic: enabled: false
