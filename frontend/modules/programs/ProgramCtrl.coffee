define ["app"], (app) ->
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
    app.controller 'ProgramCtrl', ProgramCtrl
