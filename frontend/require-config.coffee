require.config
    paths:
        angular: "lib/angular"
    shim:
        "angular": exports: "angular"
        "lib/angular-route": ["angular"]
    deps: ["app-bootstrap"]
