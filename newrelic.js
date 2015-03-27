var config = require('./backend/config/config');
exports.config = {
	app_name: [config.appName],
	license_key: config.newrelic.license,
	agent_enabled: config.newrelic.enabled,
	logging: {
		level: 'info'
	}
};