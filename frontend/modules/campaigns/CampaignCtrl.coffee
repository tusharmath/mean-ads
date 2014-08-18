class CampaignCtrl
    constructor: () ->
        @campaigns = [
            name: "Indiranagar Dentistry"
            startDate: new Date 10, 10, 2010
            endDate: new Date 10, 12, 2010
            commitment: 4000
            adCount: 14
            status: "active"
            program: "Engineer's Den"
        ]
angular.module('mean-ads').controller 'CampaignCtrl', CampaignCtrl
