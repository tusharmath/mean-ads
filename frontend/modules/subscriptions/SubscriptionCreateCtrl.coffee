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

    SubscriptionCreateCtrl.$inject = ["Restangular", "$location"]
    app.controller 'SubscriptionCreateCtrl', SubscriptionCreateCtrl