require.config
	baseUrl: 'static/'
	paths:
		angular: "lib/angular"
		lodash: "lib/lodash.compat"
		Restangular: "lib/restangular"
		'auth0-widget': 'lib/auth0-widget'
	shim:
		"angular": exports: "angular"
		"lib/ui-ace": ["lib/ace", "angular", "lib/mode-html", "lib/mode-css"]
		"lib/angular-route": ["angular"]
		"lib/angular-cookies": ["angular"]
		"lib/auth0-angular": ["angular"]
		"lib/ui-bootstrap-tpls": ["angular"]
		"Restangular": ["angular", "lodash"]
	deps: ["app-bootstrap"]
