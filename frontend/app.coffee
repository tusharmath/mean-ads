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
            templateUrl: 'modules/campaign'
        .when '/ads',
            templateUrl: 'modules/ad'
        .when '/keywords',
            templateUrl: 'modules/keyword'
        .when '/styles',
            templateUrl: 'modules/style'
        .otherwise redirectTo: '/'
    $locationProvider.html5Mode false
