app = require '../../app'

class SubscriptionCtrl
	constructor: (rest, route) ->
		route.populate = 'campaign'
		rest.all('subscriptions').getList(route).then (@subscriptions) =>
	onInActiveCss: (subscription)->
		if subscription.usedCredits >= subscription.totalCredits then "text-danger" else ""


SubscriptionCtrl.$inject = ['Restangular', '$routeParams']
app.controller 'SubscriptionListCtrl', SubscriptionCtrl
