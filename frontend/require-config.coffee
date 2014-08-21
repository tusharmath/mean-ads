require.config
    paths:
        angular: "lib/angular"
    shim:
        "angular": exports: "angular"
        "lib/angular-route": ["angular"]
        "app-bootstrap": [
            "app"
            "lib/angular-route"
            "modules/nav/NavbarCtrl"
            "modules/MainCtrl"
            "modules/programs/ProgramCtrl"
            "modules/campaigns/CampaignCtrl"
            "modules/subscriptions/SubscriptionCtrl"
        ]
    deps: ["app-bootstrap"]
