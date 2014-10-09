'use strict'
module.exports =
	mongo:
		uri: 'mongodb://localhost:27017/adwords'
	bragi:
		options:
			groupsEnabled: [
				'http:api'
				'application'
				'api'
				'model'
				'controller'
			]
