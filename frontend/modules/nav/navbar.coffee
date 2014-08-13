(->
  'use strict'
  injected = 0

  class NavbarCtrl
    constructor: ($location) ->
      injected = {$location}
      @modules = [
        name:"Home"
        path:"/"
       #---begin:modules---#
      ,
        name:"Campaigns"
        path:"/campaigns"

      ,
        name:"Ads"
        path:"/ads"

      ,
        name:"Styles"
        path:"/styles"

      ,
        name:"Keywords"
        path:"/keywords"


       #---end:modules---#
      ]

    isActive: (route) ->
      route is injected.$location.path()

  NavbarCtrl.$inject = ['$location']

  angular.module('mean-ads')
  .controller 'NavbarCtrl', NavbarCtrl

)()
