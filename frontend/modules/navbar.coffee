'use strict'

angular.module('meanjsAdwordsApp')
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
  