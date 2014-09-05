require [
  "angular"

  # TODO: Controllers can't be loaded here
  "modules/dashboard/DashboardCtrl"
  "modules/nav/NavbarCtrl"

  "modules/programs/ProgramCreateCtrl"
  "modules/programs/ProgramCtrl"


  "modules/campaigns/CampaignCtrl"
  "modules/campaigns/CampaignCreateCtrl"

  "modules/subscriptions/SubscriptionCtrl"
  "modules/subscriptions/SubscriptionCreateCtrl"

  "modules/styles/StyleCtrl"
  "modules/styles/StyleCreateCtrl"

  "modules/keywords/KeywordCtrl"

  "modules/directives/ShadowDom"
], (angular) ->
    angular.bootstrap document, ['mean-ads']
