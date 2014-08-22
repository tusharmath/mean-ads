require [
    "angular"
    "modules/MainCtrl"
    "modules/nav/NavbarCtrl"
    "modules/programs/ProgramCtrl"
    "modules/campaigns/CampaignCtrl"
    "modules/subscriptions/SubscriptionCtrl"
    "modules/styles/StyleCtrl"
], (angular) ->
    angular.bootstrap document, ['mean-ads']
