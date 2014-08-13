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
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode false
