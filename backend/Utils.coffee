DateProvider = require './providers/DateProvider'
{annotate, Inject} = require 'di'
class Utils
	constructor: (@date) ->
	# Determines if the subscription has expired
	hasSubscriptionExpired: (subscription) ->
		{startDate} = subscription
		[year, month, date] = @date.split startDate

		date += subscription.campaign.days
		endDate = @date.create year, month, date
		if endDate  < @date.now() then yes else no
annotate Utils, new Inject DateProvider
module.exports = Utils