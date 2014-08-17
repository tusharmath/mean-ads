class ProgramCtrl
    constructor: () ->
        @programs = [
            name: "doctors paradise"
            style: "Blue front"
            slotCount: 123
            gauge: "clicks"
            adCount : 345
            status: "active"
            algorithm: "round robin"
        ,
            name: "engineer's den"
            style: "slim looking"
            slotCount: 19
            gauge: "impressions"
            adCount : 37
            status: "stale"
            algorithm: "weighted selections"
        ]

    isActive: (route) ->
        route is injected.$location.path()

angular.module('mean-ads').controller 'ProgramCtrl', ProgramCtrl
