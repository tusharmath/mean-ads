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
annotate Utils, new Inject DateProvider
module.exports = Utils