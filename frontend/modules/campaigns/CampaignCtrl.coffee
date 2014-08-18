class CampaignCtrl
    constructor: () ->
        @campaigns = [
            name: "Indiranagar Dentistry"
            duration: "6 months"
            commitment: 4000
            gauge: "clicks"
            adCount: 14
            status: "success"
            program: "Engineer's Den"
        ,
            name: "Kormangala Orthopedics"
            duration: "3 months"
            commitment: 100
            gauge : "impressions"
            adCount: 198
            status: "danger"
            program: "Slim Looking"
        ]
angular.module('mean-ads').controller 'CampaignCtrl', CampaignCtrl
