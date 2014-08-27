define ["app"], (app) ->
    class SubscriptionCtrl
        constructor: (rest) ->
            rest.all('subscriptions').getList().then (@subscriptions) =>
    SubscriptionCtrl.$inject = ['Restangular']
    app.controller 'SubscriptionCtrl', SubscriptionCtrl
