define ["angular"], ->
    class ProgramCtrl
        constructor: () ->
            @programs = [
                name: "doctors paradise"
                style: "Blue front"
                slotCount: 123
                gauge: "clicks"
                campaignCount : 345
                status: "active"
                algorithm: "round robin"
            ,
                name: "engineer's den"
                style: "slim looking"
                slotCount: 19
                gauge: "impressions"
                campaignCount : 37
                status: "stale"
                algorithm: "weighted selections"
            ]
    angular.module('mean-ads').controller 'ProgramCtrl', ProgramCtrl
