require.config
    baseUrl: 'static/'
    paths:
        angular: "lib/angular"
        Restangular: "lib/restangular"
    shim:
        "angular": exports: "angular"
        "lib/angular-route": ["angular"]
        "Restangular": ["angular", "lib/lodash.compat"]
    deps: ["app-bootstrap"]
