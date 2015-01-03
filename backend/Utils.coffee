DateProvider = require './providers/DateProvider'
{annotate, Inject} = require 'di'
class Utils
	constructor: (@dateP) ->
	dateSplit:(date) ->
		[
			date.getFullYear()
			date.getMonth()
			date.getDate()
		]
	# Determines if the subscription has expired
	# TODO: Could be a part of subscription schema
	hasSubscriptionExpired: (subscription) ->
		{startDate} = subscription
		[year, month, date] = @dateSplit startDate

		date += subscription.campaign.days
		endDate = new Date year, month, date
		endDate < @dateP.now()
annotate Utils, new Inject DateProvider
module.exports = Utils