var config = require('./backend/config/config');
exports.config = config.newRelic;
exports.config = {
	app_name: [config.appName],
	license_key: config.newrelic.license,
	relic_enabled: config.enabled,
	logging: {
		level: 'info'
	}
};