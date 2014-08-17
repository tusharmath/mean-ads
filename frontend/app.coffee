'use strict'

angular.module('mean-ads', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute',
    'ngAnimate'
])
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
        .when '/',
            templateUrl: 'modules/main'
            controller: 'MainCtrl'
        .when '/campaigns',
            templateUrl: 'modules/campaigns/campaign'
        .when '/ads',
            templateUrl: 'modules/ads/ad'
        .when '/keywords',
            templateUrl: 'modules/keywords/keyword'
        .when '/styles',
            templateUrl: 'modules/styles/style'
        .otherwise redirectTo: '/'
    $locationProvider.html5Mode false
