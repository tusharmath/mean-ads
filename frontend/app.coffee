"use strict"

angular.module("mean-ads", [
    "ngCookies",
    "ngResource",
    "ngSanitize",
    "ngRoute"
])
.config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
        .when "/",
            templateUrl: "modules/main"
            controller: "MainCtrl"
        .when "/programs",
            templateUrl: "modules/programs/program"
            controller: "ProgramCtrl as prgCtrl"
        .when "/campaigns",
            templateUrl: "modules/campaigns/campaign"
            controller: "CampaignCtrl as cmpCtrl"
        .when "/ads",
            templateUrl: "modules/ads/ad"
        .when "/keywords",
            templateUrl: "modules/keywords/keyword"
        .when "/styles",
            templateUrl: "modules/styles/style"
        .otherwise redirectTo: "/"
    $locationProvider.html5Mode false
