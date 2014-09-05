require.config
    baseUrl: 'static/'
    paths:
        angular: "lib/angular"
        lodash: "lib/lodash.compat"
        Restangular: "lib/restangular"
    shim:
        "angular": exports: "angular"
        "lib/angular-route": ["angular"]
        "Restangular": ["angular", "lodash"]
    deps: ["app-bootstrap"]
