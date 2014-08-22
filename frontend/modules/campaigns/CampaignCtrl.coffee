define ["app"], (app) ->
    class CampaignCtrl
        constructor: () ->
            @campaigns = [
                name: "Indiranagar Dentistry"
                duration: "6 months"
                commitment: 4000
                gauge: "clicks"
                adCount: 14
                health: "success"
                status: "stopped"
                program: "Engineer's Den"
            ,
                name: "Kormangala Orthopedics"
                duration: "3 months"
                commitment: 100
                gauge : "impressions"
                adCount: 198
                health: "danger"
                status: "running"
                program: "Slim Looking"
            ]
    app.controller 'CampaignCtrl', CampaignCtrl
