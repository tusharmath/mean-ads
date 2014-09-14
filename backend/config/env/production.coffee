'use strict'

module.exports =
		env: 'production'
		coffeeCompress: true
		ip: process.env.OPENSHIFT_NODEJS_IP ||
				process.env.IP ||
				'0.0.0.0'
		port: process.env.OPENSHIFT_NODEJS_PORT ||
				process.env.PORT ||
				8080
		mongo:
				uri: process.env.MONGOLAB_URI ||
						process.env.MONGOHQ_URL ||
						process.env.OPENSHIFT_MONGODB_DB_URL +
						process.env.OPENSHIFT_APP_NAME ||
						'mongodb://root:1234567890@kahana.mongohq.com:10062/adwords'
