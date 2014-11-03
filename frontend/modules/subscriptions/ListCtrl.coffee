define ["app"], (app) ->
	class SubscriptionCtrl
		constructor: (rest, route) ->
			route.populate = 'campaign'
			rest.all('subscriptions').getList(route).then (@subscriptions) =>
	SubscriptionCtrl.$inject = ['Restangular', '$routeParams']
	app.controller 'SubscriptionListCtrl', SubscriptionCtrl
