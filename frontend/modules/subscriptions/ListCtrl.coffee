app = require '../../app'

class SubscriptionCtrl
	constructor: (rest, route) ->
		route.populate = 'campaign'
		rest.all('subscriptions').getList(route).then (@subscriptions) =>
	# TODO: Very bad function. Must be moved to a service/utils
	endDate: (subscription) ->
		{startDate} = subscription
		startDate = new Date startDate
		[year, month, date] = [
			startDate.getFullYear()
			startDate.getMonth()
			startDate.getDate()
		]

		date += subscription.campaign.days
		new Date year, month, date
	# TODO: Use Utils.hasSubscriptionExpired
	onExpiredCss: (subscription)->
		if @endDate(subscription) < Date.now() then "text-danger" else no
	onInActiveCss: (subscription)->
		if subscription.usedCredits >= subscription.totalCredits then "text-danger" else ""


SubscriptionCtrl.$inject = ['Restangular', '$routeParams']
app.controller 'SubscriptionListCtrl', SubscriptionCtrl
