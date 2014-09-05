define ["app"], (app) ->
    class SubscriptionCreateCtrl
        constructor: (@rest, @loc) ->
            @subscription = {}
            rest.all('campaigns').getList().then (@campaigns) =>
        save: () ->
            @rest
            .all 'subscriptions'
            .post @subscription
            .then () =>
                @loc.path '/subscriptions'
        onCampaignSelect: () ->
            @rest
            .one 'campaigns', @subscription.campaign
            .then (@campaign) =>
                @rest
                .one 'program', @campaign.program.id
                .then(@program) =>



    SubscriptionCreateCtrl.$inject = ["Restangular", "$location"]
    app.controller 'SubscriptionCreateCtrl', SubscriptionCreateCtrl