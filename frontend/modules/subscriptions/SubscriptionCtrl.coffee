define ["angular"], (angular) ->
    class SubscriptionCtrl
        constructor: () ->
            @subscriptions = [
                client: "Fortis Multispeciality Hospital"
                campaign: "Indiranagar Dentistry"
                startDate: new Date 1, 1, 2010
                endDate: new Date 1, 1, 2014
                creditsRemaining: 4094
                totalCredits: 9876
                gauge: "clicks"
            ,
                client: "Manipal Dental Clinic"
                campaign: "Kormangala Orthopedics"
                startDate: new Date 1, 1, 2019
                endDate: new Date 1, 1, 2114
                creditsRemaining: 94
                totalCredits: 976
                gauge: "impressions"
            ]
    angular.module('mean-ads').controller 'SubscriptionCtrl', SubscriptionCtrl
