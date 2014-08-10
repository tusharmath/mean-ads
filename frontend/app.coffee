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
      .when '/admin',
        templateUrl: 'modules/admin/admin'
        controller: 'AdminCtrl'
      .otherwise
        redirectTo: '/'

    $locationProvider.html5Mode true
