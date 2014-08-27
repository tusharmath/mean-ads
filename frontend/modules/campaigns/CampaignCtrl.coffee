define ["app"], (app) ->
    class CampaignCtrl
        constructor: (rest) ->
            rest.all('campaigns').getList().then (@campaigns) =>
    CampaignCtrl.$inject = ['Restangular']
    app.controller 'CampaignCtrl', CampaignCtrl
