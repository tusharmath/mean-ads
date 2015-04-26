config = require '../config/config'
DateProvider = require '../providers/DateProvider'
_  = require 'lodash'
{MeanError} = require '../config/error-codes'
# {Inject, annotate} = require 'di'
class DispatchStamper
	constructor: (@date) ->
	_reduce: (m, i) ->
		if m isnt ''
			m += ','
		m += "#{i.subscription}:#{i.timestamp.getTime()}"
	_getMaxDispatchCount: -> config.maxDispatchStampCount
	_getConversionMaxAge: -> config.conversionMaxAge
	_removeOldStamps: (stamps) ->
		maxCount = @_getMaxDispatchCount()
		_.sortBy stamps, (v) -> v.timestamp
		.slice _.max [stamps.length - maxCount, 0]

	_updateOrAddNewStamp: (stamps, newStamp) ->

		oldStamp = _.find stamps, (v) ->
			v.subscription.toString() is newStamp.subscription.toString()
		if not oldStamp
			stamps.push newStamp
		else
			oldStamp.timestamp = newStamp.timestamp
		stamps

	appendStamp : (stampStr, dispatch) ->
		stamps = @parseStamp stampStr
		{subscription} = dispatch
		timestamp = @date.now()

		stampsUpdatedOrAdded = @_updateOrAddNewStamp stamps, {subscription, timestamp}
		stampsOldRemoved = @_removeOldStamps stampsUpdatedOrAdded
		_.reduce stampsOldRemoved, @_reduce, ''
	parseStamp: (stampStr) ->
		return [] if not stampStr
		_.map stampStr.split(','), (i) ->
			[subscription, timestamp] = i.split ':'
			timestamp = new Date parseInt timestamp, 10
			if not subscription or timestamp.toString() is 'Invalid Date'
				throw new MeanError 'Can not parse dispatch timestamp.'
			{subscription, timestamp}
	isConvertableSubscription: (stampStr, subscriptionId) ->
		_.any @parseStamp(stampStr), (v) =>
			v.subscription is subscriptionId and
			@date.now().getTime() - v.timestamp < @_getConversionMaxAge()

# annotate DispatchStamper, new Inject DateProvider
module.exports = DispatchStamper
