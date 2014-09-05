require.config
	baseUrl: 'static/'
	paths:
		angular: "lib/angular"
		lodash: "lib/lodash.compat"
		Restangular: "lib/restangular"
	shim:
		"angular": exports: "angular"
		"lib/ui-ace": ["lib/ace", "angular", "lib/mode-html", "lib/mode-css"]
		"lib/angular-route": ["angular"]
		"Restangular": ["angular", "lodash"]
	deps: ["app-bootstrap"]
