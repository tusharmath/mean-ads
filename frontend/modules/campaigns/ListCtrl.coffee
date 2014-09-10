define ["app"], (app) ->
    class CampaignCtrl
        constructor: (@rest) ->
            @rest.all('campaigns').getList().then (@campaigns) =>
        toggleStatus: (campaign) ->
          campaign.isEnabled = !!! campaign.isEnabled
          @rest.one 'campaigns', campaign._id
          .patch isEnabled: campaign.isEnabled
          .then =>
            @rest.all('campaigns' ).getList().then (@campaigns) =>

    CampaignCtrl.$inject = ['Restangular']
    app.controller 'CampaignListCtrl', CampaignCtrl
