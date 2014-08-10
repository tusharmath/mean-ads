'use strict'

angular.module('mean-ads')
.controller 'NavbarCtrl', ($scope, $location) ->
  $scope.modules = [
    name:"Home"
    path:"/"
   #---begin:modules---#
   #---end:modules---#
  ]
  $scope.isActive = (route) ->
    route is $location.path()
  return
