define ["app"], (app) ->
	class SubscriptionCtrl
		constructor: (rest, route) ->
			rest.all('subscriptions').getList(route).then (@subscriptions) =>
	SubscriptionCtrl.$inject = ['Restangular', '$routeParams']
	app.controller 'SubscriptionListCtrl', SubscriptionCtrl
