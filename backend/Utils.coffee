MeanError = require './modules/MeanError'
module.exports = ->
	dateSplit:(date) ->
		[
			date.getFullYear()
			date.getMonth()
			date.getDate()
		]
	# Determines if the subscription has expired
	# TODO: Could be a part of subscription schema
	# TODO: Remove
	# hasSubscriptionExpired: (subscription, now) ->
	# 	throw new MeanError 'now should be of date type' if Date isnt @getType now
	# 	{startDate} = subscription
	# 	[year, month, date] = @dateSplit startDate

	# 	date += subscription.campaign.days
	# 	endDate = new Date year, month, date
	# 	endDate < now
	camelCaseToSnakeCase: (str) ->
		out = ""
		for v,k in str
			if v.toUpperCase() is v and k isnt 0
				out += '-'
			out+= v.toLowerCase()
		out
	snakeCaseToCamelCase: (str, separator = '-') ->
		out = ""
		capitalize = yes
		for v in str
			if v is separator
				capitalize = yes
			else if capitalize is yes
				out += v.toUpperCase()
				capitalize = no
			else
				out += v
		out
	getType: (item) ->
		return 'null' if item is null
		return 'undefined' if item is undefined
		x = {}
		x.toString.call item
		.replace /\[object /, ''
		.replace ']', ''