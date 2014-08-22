require [
    "angular"
    "modules/MainCtrl"
    "modules/nav/NavbarCtrl"
    "modules/programs/ProgramCtrl"
    "modules/campaigns/CampaignCtrl"
    "modules/subscriptions/SubscriptionCtrl"
    "modules/styles/StyleCtrl"
    "modules/keywords/KeywordCtrl"
], (angular) ->
    angular.bootstrap document, ['mean-ads']
