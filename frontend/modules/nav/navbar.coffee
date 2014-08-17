injected = 0

class NavbarCtrl
    constructor: ($location) ->
        injected = {$location}
        @modules = [
            name: "Home"
            path: "/"
           #---begin:modules---#
        ,
            name: "Programs"
            path: "/programs"
        ,
            name: "Slots"
            path: "/slots"
        ,
            name: "Ads"
            path: "/ads"
        ,
            name: "Styles"
            path: "/styles"
        ,
            name: "Keywords"
            path: "/keywords"
        ]

    isActive: (route) ->
        route is injected.$location.path()

NavbarCtrl.$inject = ['$location']

angular.module('mean-ads').controller 'NavbarCtrl', NavbarCtrl
